require 'rails_helper'

RSpec.describe 'teachers/Questions', type: :request do
  before do
    @admin = create(:admin)
    @api_key = @admin.activate
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

      it '#update 200' do
        put '/api/teachers/problems/' + problem[:id].to_s + '/questions/' + question[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] },
            params: { question: {
              sentence: question[:sentence],
              correct: question[:correct]
            } }
        expect(response.status).to eq(200)
      end

      it '#update 404' do
        put '/api/teachers/problems/' + problem[:id].to_s + '/questions/0',
            headers: { 'access-token': @api_key[:access_token] },
            params: { question: {
              sentence: nil,
              correct: nil
            } }
        expect(response.status).to eq(404)
      end

      it '#update 422' do
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

  describe 'DELETE /api/teachers/problems/:problem_id/questions/:id' do
    let!(:problem) { create(:problem, :with_user) }
    let!(:question) { create(:question, problem: problem) }

    it '#destroy 200' do
      count = Question.count
      delete '/api/teachers/problems/' + problem[:id].to_s + '/questions/' + question[:id].to_s,
             headers: { 'access-token': @api_key[:access_token] }
      expect(response.status).to eq(200)
      expect(Question.count).to eq(count - 1)
    end

    it '#destroy 404' do
      delete '/api/teachers/problems/0/questions/0',
             headers: { 'access-token': @api_key[:access_token] }
      expect(response.status).to eq(404)
    end
  end

  describe 'POST /api/teachers/problems/:problem_id/questions/download_index' do
    let!(:problem) { create(:problem, :with_user) }
    let!(:question) { create(:question, problem: problem) }

    it '#download_index 200' do
      post '/api/teachers/problems/' + problem[:id].to_s + '/questions/download_index',
           headers: { 'access-token': @api_key[:access_token] }
      expect(response.status).to eq(200)
    end

    it '#download_index 404' do
      post '/api/teachers/problems/0/questions/download_index',
           headers: { 'access-token': @api_key[:access_token] }
      expect(response.status).to eq(404)
    end
  end

  describe 'POST /api/teachers/problems/:problem_id/questions/download_test' do
    let!(:problem) { create(:problem, :with_user) }
    let!(:question) { create(:question, problem: problem) }

    it '#download_index 200' do
      post '/api/teachers/problems/' + problem[:id].to_s + '/questions/download_test',
           headers: { 'access-token': @api_key[:access_token] },
           params: { count: 20 }
      expect(response.status).to eq(200)
    end

    it '#download_index 400' do
      post '/api/teachers/problems/' + problem[:id].to_s + '/questions/download_test',
           headers: { 'access-token': @api_key[:access_token] },
           params: { count: 10 }
      expect(response.status).to eq(400)
    end

    it '#download_index 404' do
      post '/api/teachers/problems/0/questions/download_test',
           headers: { 'access-token': @api_key[:access_token] }
      expect(response.status).to eq(404)
    end
  end

  describe '管理者以外に対するテスト' do
    let!(:teacher) { create(:teacher) }
    let!(:teacher_api_key) { teacher.activate }

    it '#destroy 403' do
      delete '/api/teachers/problems/0/questions/0',
             headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(403)
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
      patch '/api/teachers/problems/0/questions/0',
            headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#destroy 401' do
      delete '/api/teachers/problems/0/questions/0',
             headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#download_index 401' do
      post '/api/teachers/problems/0/questions/download_index',
           headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#download_test 401' do
      post '/api/teachers/problems/0/questions/download_test',
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
      patch '/api/teachers/problems/0/questions/0'
      expect(response.status).to eq(401)
    end

    it '#destroy 401' do
      delete '/api/teachers/problems/0/questions/0'
      expect(response.status).to eq(401)
    end

    it '#download_index 401' do
      post '/api/teachers/problems/0/questions/download_index'
      expect(response.status).to eq(401)
    end

    it '#download_test 401' do
      post '/api/teachers/problems/0/questions/download_test'
      expect(response.status).to eq(401)
    end
  end
end
