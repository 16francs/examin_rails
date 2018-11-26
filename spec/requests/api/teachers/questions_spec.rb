require 'rails_helper'

RSpec.describe 'teachers/Questions', type: :request do
  before do
    @teacher = create(:teacher)
    @api_key = @teacher.activate
  end

  describe '正しい講師に対するテスト' do
    describe 'GET /api/teachers/problems/:problem_id/questions' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }
      let!(:answer) { create(:answer, question: question) }

      it '#index 200' do
        get '/api/teachers/problems/' + problem[:id].to_s + '/questions',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['questions'][0]['id']).to_not eq(nil)
        expect(json['questions'][0]['sentence']).to_not eq(nil)
        expect(json['questions'][0]['type']).to_not eq(nil)
        expect(json['questions'][0]['correct']).to_not eq(nil)
        expect(json['questions'][0]['created_at']).to_not eq(nil)
        expect(json['questions'][0]['updated_at']).to_not eq(nil)
        expect(json['questions'][0]['answers'][0]['id']).to_not eq(nil)
        expect(json['questions'][0]['answers'][0]['choice']).to_not eq(nil)
      end
    end
  end

  describe '講師以外に対するテスト' do
    let!(:student) { create(:student) }
    let!(:student_api_key) { student.activate }

    it '#index 401' do
      get '/api/teachers/problems/0/questions',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン講師に対するテスト' do
    it '#index 401' do
      get '/api/teachers/problems/0/questions'
      expect(response.status).to eq(401)
    end
  end
end
