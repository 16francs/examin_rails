require 'rails_helper'

RSpec.describe 'Students/Problems', type: :request do
  before do
    @student = create(:student)
    @api_key = @student.activate
  end

  describe '正しい生徒に対するテスト' do
    describe 'GET /api/students/problems' do
      let!(:problem) { create(:problem, :with_user) }

      it '#index 200' do
        get '/api/students/problems',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['problems'][0]['id']).to_not eq(nil)
        expect(json['problems'][0]['title']).to_not eq(nil)
        expect(json['problems'][0]['content']).to_not eq(nil)
        expect(json['problems'][0]['user_id']).to_not eq(nil)
        expect(json['problems'][0]['created_at']).to_not eq(nil)
        expect(json['problems'][0]['updated_at']).to_not eq(nil)
      end
    end

    describe 'GET /api/students/problems/:id' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }
      let!(:answer) { create(:answer, question: question) }

      it '#show 200' do
        get '/api/students/problems/' + problem[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['problem']['id']).to_not eq(nil)
        expect(json['problem']['title']).to_not eq(nil)
        expect(json['problem']['content']).to_not eq(nil)
        expect(json['problem']['user_id']).to_not eq(nil)
        expect(json['problem']['created_at']).to_not eq(nil)
        expect(json['problem']['updated_at']).to_not eq(nil)
        expect(json['questions'][0]['id']).to_not eq(nil)
        expect(json['questions'][0]['sentence']).to_not eq(nil)
        expect(json['questions'][0]['type']).to_not eq(nil)
        expect(json['questions'][0]['correct']).to_not eq(nil)
        expect(json['questions'][0]['answers'][0]['id']).to_not eq(nil)
        expect(json['questions'][0]['answers'][0]['choice']).to_not eq(nil)
      end

      it '#show 404' do
        get '/api/students/problems/0',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(404)
      end
    end

    describe 'POST /api/students/problems/:id/achievement' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }
      let!(:achievement) { build(:achievement) }

      it '#achievement 200' do
        problems_user_count = ProblemsUser.count
        achievement_count = Achievement.count
        post '/api/students/problems/' + problem[:id].to_s + '/achievement',
             headers: { 'access-token': @api_key[:access_token] },
             params: { problems_user: { achievements_attributes: [{
               question_id: question[:id],
               result: achievement[:result],
               user_choice: achievement[:user_choice]
             }] } }
        expect(response.status).to eq(200)
        expect(ProblemsUser.count).to eq(problems_user_count + 1)
        expect(Achievement.count).to eq(achievement_count + 1)
        # 外部キーの確認
        json = JSON.parse(response.body)
        expect(json['problems_user']['problem_id']).to eq(problem[:id])
        expect(json['problems_user']['user_id']).to eq(@student[:id])
      end

      it '#achievement 422' do
        post '/api/students/problems/' + problem[:id].to_s + '/achievement',
             headers: { 'access-token': @api_key[:access_token] },
             params: { problems_user: { achievements_attributes: [{
               question_id: nil,
               result: nil,
               user_choice: nil
             }] } }
        expect(response.status).to eq(422)
      end
    end
  end

  describe '生徒以外に対するテスト' do
    let!(:teacher) { create(:teacher) }
    let!(:teacher_api_key) { teacher.activate }

    it '#index 401' do
      get '/api/students/problems',
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/students/problems/0',
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#achievement 401' do
      post '/api/students/problems/0/achievement',
           headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン生徒に対するテスト' do
    it '#index 401' do
      get '/api/students/problems'
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/students/problems/0'
      expect(response.status).to eq(401)
    end

    it '#achievement 401' do
      post '/api/students/problems/0/achievement'
      expect(response.status).to eq(401)
    end
  end
end
