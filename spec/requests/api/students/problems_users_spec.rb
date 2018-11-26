require 'rails_helper'

RSpec.describe 'Students/ProblemsUsers', type: :request do
  before do
    @student = create(:student)
    @api_key = @student.activate
  end

  describe '正しい生徒に対するテスト' do
    describe 'GET /api/students/problems_users' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }
      let!(:problems_user) { create(:problems_user, problem: problem, user: @student) }
      let!(:achievement) { create(:achievement, problems_user: problems_user, question: question) }

      it '#index 200' do
        get '/api/students/problems_users',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['problems_users'][0]['id']).to_not eq(nil)
        expect(json['problems_users'][0]['problem_id']).to_not eq(nil)
        expect(json['problems_users'][0]['created_at']).to_not eq(nil)
        expect(json['problems_users'][0]['updated_at']).to_not eq(nil)
      end
    end

    describe 'GET /api/students/problems_users/:id' do
      let!(:problem) { create(:problem, :with_user) }
      let!(:question) { create(:question, problem: problem) }
      let!(:problems_user) { create(:problems_user, problem: problem, user: @student) }
      let!(:achievement) { create(:achievement, problems_user: problems_user, question: question) }

      it '#show 200' do
        get '/api/students/problems_users/' + problems_user[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['problems_user']['id']).to_not eq(nil)
        expect(json['problems_user']['problem_id']).to_not eq(nil)
        expect(json['problems_user']['created_at']).to_not eq(nil)
        expect(json['problems_user']['updated_at']).to_not eq(nil)
        expect(json['achievements'][0]['id']).to_not eq(nil)
        expect(json['achievements'][0]['question_id']).to_not eq(nil)
        expect(json['achievements'][0]['result']).to_not eq(nil)
        expect(json['achievements'][0]['user_choice']).to_not eq(nil)
        expect(json['achievements'][0]['question']['sentence']).to_not eq(nil)
        expect(json['achievements'][0]['question']['correct']).to_not eq(nil)
      end
    end
  end

  describe '正しくない生徒に対するテスト' do
    let!(:other_student) { create(:student) }
    let!(:other_student_api_key) { other_student.activate }
    let!(:problems_user) { create(:problems_user, :with_problem, user: @student) }

    it '#show 403' do
      get '/api/students/problems_users/' + problems_user[:id].to_s,
          headers: { 'access-token': other_student_api_key[:access_token] }
      expect(response.status).to eq(403)
    end
  end

  describe '生徒以外に対するテスト' do
    let!(:teacher) { create(:teacher) }
    let!(:teacher_api_key) { teacher.activate }

    it '#index 401' do
      get '/api/students/problems_users',
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/students/problems_users/0',
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン生徒に対するテスト' do
    it '#index 401' do
      get '/api/students/problems_users'
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/students/problems_users/0'
      expect(response.status).to eq(401)
    end
  end
end
