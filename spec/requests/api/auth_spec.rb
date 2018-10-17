require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  before do
    @user = create(:user)
    @api_key = @user.activate
  end

  describe 'POST /api/auth' do
    it 'ログイン成功' do
      post '/api/auth', params: { login_id: @user[:login_id], password: '12345678' }
      expect(response.status).to eq(200)
      # jsonの検証
      json = JSON.parse(response.body)
      expect(json['data']['access_token']).to eq(@api_key[:access_token])
      expect(json['data']['user']['id']).to eq(@user[:id])
      expect(json['data']['user']['role']).to eq(@user[:role])
    end

    it 'ログイン失敗' do
      post '/api/auth'
      expect(response.status).to eq(401)
    end

    it 'api_keyが有効期限切れ時にログイン' do
      @api_key[:expires_at], expires_at = DateTime.now - 1
      @api_key.save
      # ログイン処理
      post '/api/auth', params: { login_id: @user[:login_id], password: '12345678' }
      # 有効期限が更新されているかの確認
      expect(@api_key[:expires_at]).to_not eq(expires_at)
    end
  end

  describe 'Delete /api/auth' do
    it 'ログインユーザー' do
      delete '/api/auth', headers: { 'access-token': @api_key[:access_token] }
      expect(response.status).to eq(200)
      # ログアウト状態になっていることを確認
      @api_key = ApiKey.find_by(user_id: @user)
      expect(@api_key[:activated]).to eq(false)
    end

    it '未ログインユーザー' do
      delete '/api/auth'
      expect(response.status).to eq(404)
    end
  end
end
