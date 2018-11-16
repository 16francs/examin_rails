require 'rails_helper'

RSpec.describe 'Students/Questions', type: :request do
  before do
    @student = create(:student)
    @api_key = @student.activate
  end

  describe '正しい生徒に対するテスト' do
    describe 'GET /api/students/problems/:problem_id/questions' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }
      let!(:answer) { create(:answer, question: question) }

      it '#index 200' do
        get '/api/students/problems/' + problem[:id].to_s + '/questions',
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
        expect(json['questions'][0]['problem_id']).to eq(nil)
      end

      it '#index 404' do
        get '/api/students/problems/0/questions',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(404)
      end
    end
  end

  describe '生徒以外に対するテスト' do
    let!(:teacher) { create(:teacher) }
    let!(:teacher_api_key) { teacher.activate }

    it '#index 401' do
      get '/api/students/problems/0/questions',
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン生徒に対するテスト' do
    it '#index 401' do
      get '/api/students/problems/0/questions'
      expect(response.status).to eq(401)
    end
  end
end
