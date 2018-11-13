require 'rails_helper'

RSpec.describe 'Students/Students', type: :request do
  before do
    @student = create(:student)
    @api_key = @student.activate
  end

  describe '正しい生徒に対するテスト' do
    describe 'GET /api/students/students/:id' do
      it '生徒詳細 取得' do
        get '/api/students/students/' + @student[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
      end
    end
  end

  describe '正しくない生徒に対するテスト' do
    before do
      @other_student = create(:student)
      @other_api_key = @other_student.activate
    end

    it '生徒詳細 取得 NG' do
      get '/api/students/students/' + @student[:id].to_s,
          headers: { 'access-token': @other_api_key[:access_token] }
      expect(response.status).to eq(403)
    end
  end

  describe '生徒以外に対するテスト' do
    before do
      @teacher = create(:teacher)
      @teacher_api_key = @teacher.activate
    end

    it '生徒詳細 取得 NG' do
      get '/api/students/students/' + @student[:id].to_s,
          headers: { 'access-token': @teacher_api_key[:access_token] }
      expect(response.status).to eq(403)
    end
  end

  describe '未ログイン生徒に対するテスト' do
    it '生徒詳細 取得 NG' do
      get '/api/students/students/' + @student[:id].to_s
      expect(response.status).to eq(401)
    end
  end
end
