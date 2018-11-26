require 'rails_helper'

RSpec.describe 'Students/Achievements', type: :request do
  before do
    @student = create(:student)
    @api_key = @student.activate
  end

  describe '正しい生徒に対するテスト' do
    let!(:problem) { create(:problem, :with_user) }
    let!(:question) { create(:question, problem: problem) }
    let!(:achievement) { build(:achievement) }

    describe 'POST /api/students/problems/:problem_id/achievements' do
      it '#create 200' do
        problems_user_count = ProblemsUser.count
        achievement_count = Achievement.count
        post '/api/students/problems/' + problem[:id].to_s + '/achievements',
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

      it '#create 422' do
        post '/api/students/problems/' + problem[:id].to_s + '/achievements',
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

    it '#create 401' do
      post '/api/students/problems/0/achievements',
           headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン生徒に対するテスト' do
    it '#create 401' do
      post '/api/students/problems/0/achievements'
      expect(response.status).to eq(401)
    end
  end
end
