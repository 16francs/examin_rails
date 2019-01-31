# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Students::Problems', type: :request do
  let!(:student) { create(:student) }

  describe 'index action' do
    let!(:teacher) { create(:teacher) }
    let!(:problems) { create_list(:problem, 10, user: teacher) }

    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/students/problems'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(student)
        auth_params = get_auth_params(response)
        get '/api/students/problems', headers: auth_params
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
