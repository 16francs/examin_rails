# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Teachers::Problems', type: :request do
  let!(:admin) { create(:admin) }
  let!(:problem) { create(:problem, user: admin) }
  let!(:tag) { create(:tag) }
  let!(:problems_tag) { create(:problems_tag, problem: problem, tag: tag) }

  describe 'index action' do
    let!(:questions) { create_list(:question, 10, problem: problem) }

    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/teachers/problems/' + problem[:id].to_s + '/questions'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(admin)
        auth_params = get_auth_params(response)
        get '/api/teachers/problems/' + problem[:id].to_s + '/questions', headers: auth_params
      end

      it 'status: 200' do
        expect(response.status).to eq(200)
      end

      it 'json の検証' do
        json = JSON.parse(response.body)
        questions.map(&:reload)
        expect(json['questions'][0]['id']).to eq(questions[0][:id])
        expect(json['questions'][0]['sentence']).to eq(questions[0][:sentence])
        expect(json['questions'][0]['correct']).to eq(questions[0][:correct])
      end
    end
  end
end
# rubocop:enable all
