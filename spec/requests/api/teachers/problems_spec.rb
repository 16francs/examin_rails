# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Teachers::Problems', type: :request do
  let!(:admin) { create(:admin) }

  describe 'index action' do
    let!(:problems) { create_list(:problem, 10, user: admin) }

    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/teachers/problems'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(admin)
        auth_params = get_auth_params(response)
        get '/api/teachers/problems', headers: auth_params
      end

      it 'status: 200' do
        expect(response.status).to eq(200)
      end

      it 'json の検証' do
        json = JSON.parse(response.body)
        problems.map(&:reload)
        expect(json['problems'][0]['id']).to eq(problems[0][:id])
        expect(json['problems'][0]['title']).to eq(problems[0][:title])
        expect(json['problems'][0]['content']).to eq(problems[0][:content])
        expect(json['problems'][0]['teacher_name']).to eq(problems[0].user[:name])
        expect(json['problems'][0]['created_at']).to eq(default_time(problems[0][:created_at]))
        expect(json['problems'][0]['updated_at']).to eq(default_time(problems[0][:updated_at]))
      end
    end
  end
end
# rubocop:enable all
