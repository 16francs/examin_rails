require 'rails_helper'

RSpec.describe 'Teachers/Students', type: :request do
  before do
    @user = build(:user)
  end

  describe '正しい講師に対するテスト' do
    before do
      @teacher = create(:teacher)
      @api_key = @teacher.activate
    end

    it '新規生徒登録 OK' do
      post '/api/teachers/students',
           headers: { 'access-token': @api_key[:access_token] },
           params: { user: {
             name: @user[:name],
             school: @user[:school],
             login_id: @user[:login_id],
             password: '12345678',
             password_confirmation: '12345678'
           } }
      expect(response.status).to eq(200)
      # roleの値の確認 (生徒の初期権限: 0)
      json = JSON.parse(response.body)
      expect(json['data']['role']).to eq(0)
    end

    it '新規生徒登録 NG' do
      post '/api/teachers/students',
           headers: { 'access-token': @api_key[:access_token] },
           params: { user: {
             name: @user[:name],
             school: @user[:school],
             login_id: @user[:login_id],
             password: nil,
             password_confirmation: nil
           } }
      expect(response.status).to eq(422)
    end
  end

  describe '講師以外に対するテスト' do
    before do
      @student = create(:student)
      @api_key = @student.activate
    end

    it '新規生徒登録 NG' do
      post '/api/teachers/students'
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン講師に対するテスト' do
    it '新規生徒登録 NG' do
      post '/api/teachers/students'
      expect(response.status).to eq(401)
    end
  end
end
