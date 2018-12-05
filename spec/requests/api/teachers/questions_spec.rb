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

      it '#index 200' do
        get '/api/teachers/problems/' + problem[:id].to_s + '/questions',
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

    describe 'GET /api/teachers/problems/:problem_id/questions/:id' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }

      it '#show 200' do
        get '/api/teachers/problems/' + problem[:id].to_s + '/questions/' + question[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['question']['id']).to_not eq(nil)
        expect(json['question']['sentence']).to_not eq(nil)
        expect(json['question']['correct']).to_not eq(nil)
        expect(json['question']['created_at']).to_not eq(nil)
        expect(json['question']['updated_at']).to_not eq(nil)
      end

      it '#show 404' do
        get '/api/teachers/problems/' + problem[:id].to_s + '/questions/0',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(404)
      end
    end

    describe 'POST /api/teachers/problems/:problem_id/questions' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { build(:question) }

      it '#create 200' do
        post '/api/teachers/problems/' + problem[:id].to_s + '/questions',
             headers: { 'access-token': @api_key[:access_token] },
             params: { question: {
               sentence: question[:sentence],
               correct: question[:correct]
             } }
        expect(response.status).to eq(200)
      end

      it '#create 422' do
        post '/api/teachers/problems/' + problem[:id].to_s + '/questions',
             headers: { 'access-token': @api_key[:access_token] },
             params: { question: {
               sentence: nil,
               correct: nil
             } }
        expect(response.status).to eq(422)
      end
    end

    describe 'GET /api/teachers/problems/:problem_id/questions/:id/edit' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }

      it '#edit 200' do
        get '/api/teachers/problems/' + problem[:id].to_s + '/questions/' + question[:id].to_s + '/edit',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
      end

      it '#edit 404' do
        get '/api/teachers/problems/' + problem[:id].to_s + '/questions/0/edit',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(404)
      end
    end

    describe 'PUT /api/teachers/problems/:problem_id/questions/:id' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }

      it '#edit 200' do
        put '/api/teachers/problems/' + problem[:id].to_s + '/questions/' + question[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] },
            params: { question: {
              sentence: question[:sentence],
              correct: question[:correct]
            } }
        expect(response.status).to eq(200)
      end

      it '#edit 404' do
        put '/api/teachers/problems/' + problem[:id].to_s + '/questions/0',
            headers: { 'access-token': @api_key[:access_token] },
            params: { question: {
              sentence: nil,
              correct: nil
            } }
        expect(response.status).to eq(404)
      end

      it '#edit 422' do
        put '/api/teachers/problems/' + problem[:id].to_s + '/questions/' + question[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] },
            params: { question: {
              sentence: nil,
              correct: nil
            } }
        expect(response.status).to eq(422)
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

    it '#show 401' do
      get '/api/teachers/problems/0/questions/0/',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#create 401' do
      post '/api/teachers/problems/0/questions',
           headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#edit 401' do
      get '/api/teachers/problems/0/questions/0/edit',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#update 401' do
      get '/api/teachers/problems/0/questions/0',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン講師に対するテスト' do
    it '#index 401' do
      get '/api/teachers/problems/0/questions'
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/teachers/problems/0/questions/0/'
      expect(response.status).to eq(401)
    end

    it '#create 401' do
      post '/api/teachers/problems/0/questions'
      expect(response.status).to eq(401)
    end

    it '#edit 401' do
      get '/api/teachers/problems/0/questions/0/edit'
      expect(response.status).to eq(401)
    end

    it '#update 401' do
      get '/api/teachers/problems/0/questions/0'
      expect(response.status).to eq(401)
    end
  end
end
