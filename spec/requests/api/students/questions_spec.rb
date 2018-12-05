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

      it '#index 200' do
        get '/api/students/problems/' + problem[:id].to_s + '/questions',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['questions'][0]['id']).to_not eq(nil)
        expect(json['questions'][0]['sentence']).to_not eq(nil)
        expect(json['questions'][0]['correct']).to_not eq(nil)
        expect(json['questions'][0]['created_at']).to_not eq(nil)
        expect(json['questions'][0]['updated_at']).to_not eq(nil)
      end
    end

    describe 'GET: /api/students/problems/:problem_id/questions/random' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }

      describe '#random 200' do
        it 'count == null' do
          get '/api/students/problems/' + problem[:id].to_s + '/questions/random',
              headers: { 'access-token': @api_key[:access_token] }
          expect(response.status).to eq(200)
          # jsonの検証
          json = JSON.parse(response.body)
          expect(json['test_type']).to eq(1)
          expect(json['count']).to_not eq(nil)
          expect(json['questions'].length).to_not eq(0)
        end

        it 'test_type == 1' do
          get '/api/students/problems/' + problem[:id].to_s + '/questions/random',
              headers: { 'access-token': @api_key[:access_token] },
              params: { test_type: 1, count: 1 }
          expect(response.status).to eq(200)
          # jsonの検証
          json = JSON.parse(response.body)
          expect(json['test_type']).to eq(1)
          expect(json['count']).to_not eq(nil)
          expect(json['questions'][0]['question_id']).to_not eq(nil)
          expect(json['questions'][0]['sentence']).to_not eq(nil)
          expect(json['questions'][0]['correct']).to_not eq(nil)
          expect(json['questions'][0]['answers'].length).to eq(4)
        end

        it 'test_type == 2' do
          get '/api/students/problems/' + problem[:id].to_s + '/questions/random',
              headers: { 'access-token': @api_key[:access_token] },
              params: { test_type: 2, count: 1 }
          expect(response.status).to eq(200)
          # jsonの検証
          json = JSON.parse(response.body)
          expect(json['test_type']).to eq(2)
          expect(json['count']).to_not eq(nil)
          expect(json['questions'][0]['question_id']).to_not eq(nil)
          expect(json['questions'][0]['sentence']).to_not eq(nil)
          expect(json['questions'][0]['correct']).to_not eq(nil)
          expect(json['questions'][0]['answers'].length).to eq(0)
        end
      end

      describe '#random 400' do
        it 'test_type == 0 NG' do
          get '/api/students/problems/' + problem[:id].to_s + '/questions/random',
              headers: { 'access-token': @api_key[:access_token] },
              params: { test_type: 0, count: 1 }
          expect(response.status).to eq(400)
        end
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

    it '#random 401' do
      get '/api/students/problems/0/questions/random',
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン生徒に対するテスト' do
    it '#index 401' do
      get '/api/students/problems/0/questions'
      expect(response.status).to eq(401)
    end

    it '#random 401' do
      get '/api/students/problems/0/questions/random'
      expect(response.status).to eq(401)
    end
  end
end
