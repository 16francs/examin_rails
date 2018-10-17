require 'rails_helper'

RSpec.describe 'Teachers/Teachers', type: :request do
  before do
    @user = build(:user)
  end

  describe '正しい講師に対するテスト' do
    before do
      @teacher = create(:teacher)
      @api_key = @teacher.activate
    end

    describe 'POST /api/teachers/teachers' do
      it '新規講師登録 OK' do
        post '/api/teachers/teachers',
             headers: { 'access-token': @api_key[:access_token] },
             params: { user: {
               name: @user[:name],
               school: @user[:school],
               login_id: @user[:login_id],
               password: '12345678',
               password_confirmation: '12345678'
             } }
        expect(response.status).to eq(200)
        # roleの値の確認 (講師の初期権限: 1)
        json = JSON.parse(response.body)
        expect(json['data']['role']).to eq(1)
      end

      it '新規講師登録 NG' do
        post '/api/teachers/teachers',
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
  end

  describe '未ログイン講師に対するテスト' do
    it '新規講師登録 NG' do
      post '/api/teachers/teachers'
      expect(response.status).to eq(401)
    end
  end
end
