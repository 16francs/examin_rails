require 'rails_helper'

RSpec.describe 'Teachers/ProblemsUsers', type: :request do
  before do
    @teacher = create(:teacher)
    @api_key = @teacher.activate
  end

  describe '正しい講師に対するテスト' do
    describe 'GET /api/teachers/problems_users' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:problems_user) { create(:problems_user, problem: problem, user: @teacher) }

      it '#index 200' do
        get '/api/teachers/problems_users',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['problems_users'][0]['id']).to_not eq(nil)
        expect(json['problems_users'][0]['problem_id']).to_not eq(nil)
        expect(json['problems_users'][0]['user_id']).to_not eq(nil)
        expect(json['problems_users'][0]['created_at']).to_not eq(nil)
        expect(json['problems_users'][0]['updated_at']).to_not eq(nil)
        expect(json['problems_users'][0]['user']['id']).to_not eq(nil)
        expect(json['problems_users'][0]['user']['name']).to_not eq(nil)
      end
    end

    describe 'GET /api/teachers/problems_users/:id' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }
      let!(:answer) { create(:answer, question: question) }
      let!(:problems_user) { create(:problems_user, problem: problem, user: @teacher) }
      let!(:achievement) { create(:achievement, problems_user: problems_user, question: question) }

      it '#show 200' do
        get '/api/teachers/problems_users/' + problems_user[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['problems_user']['id']).to_not eq(nil)
        expect(json['problems_user']['created_at']).to_not eq(nil)
        expect(json['problems_user']['updated_at']).to_not eq(nil)
        expect(json['problems_user']['problem']['id']).to_not eq(nil)
        expect(json['problems_user']['problem']['title']).to_not eq(nil)
        expect(json['problems_user']['problem']['content']).to_not eq(nil)
        expect(json['problems_user']['user']['id']).to_not eq(nil)
        expect(json['problems_user']['user']['name']).to_not eq(nil)
        expect(json['achievements'][0]['id']).to_not eq(nil)
        expect(json['achievements'][0]['result']).to_not eq(nil)
        expect(json['achievements'][0]['user_choice']).to_not eq(nil)
        expect(json['achievements'][0]['question']['id']).to_not eq(nil)
        expect(json['achievements'][0]['question']['sentence']).to_not eq(nil)
        expect(json['achievements'][0]['question']['correct']).to_not eq(nil)
        expect(json['achievements'][0]['question']['answers'][0]['id']).to_not eq(nil)
        expect(json['achievements'][0]['question']['answers'][0]['choice']).to_not eq(nil)
      end
    end
  end

  describe '講師以外に対するテスト' do
    let!(:student) { create(:student) }
    let!(:student_api_key) { student.activate }

    it '#index 401' do
      get '/api/teachers/problems_users',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/teachers/problems_users/0',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン講師に対するテスト' do
    it '#index 401' do
      get '/api/teachers/problems_users'
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/teachers/problems_users/0'
      expect(response.status).to eq(401)
    end
  end
end
