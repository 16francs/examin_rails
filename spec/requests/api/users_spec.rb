require 'rails_helper'

RSpec.describe 'Users', type: :request do
  before do
    @user = create(:user)
    @api_key = @user.activate
  end

  describe 'POST /api/users/check_unique' do
    describe '正しいユーザー' do
      let!(:user) { create(:user) }

      it '#check_unique OK' do
        post '/api/users/check_unique',
             headers: { 'access-token': @api_key[:access_token] },
             params: { login_id: nil }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['check_unique']).to eq(true)
      end

      it '#check_unique NG' do
        post '/api/users/check_unique',
             headers: { 'access-token': @api_key[:access_token] },
             params: { login_id: user[:login_id] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['check_unique']).to eq(false)
      end
    end

    it '未ログインユーザー' do
      post '/api/users/check_unique'
      expect(response.status).to eq(401)
    end
  end

  describe 'PUT /api/users' do
    describe '正しいユーザー' do
      let!(:user) { build(:user) }

      it '#update 200' do
        put '/api/users',
            headers: { 'access-token': @api_key[:access_token] },
            params: { user: {
              name: user[:name],
              school: user[:school],
              login_id: user[:login_id],
              password: '12345678',
              password_confirmation: '12345678'
            } }
        expect(response.status).to eq(200)
      end

      it '#update 422' do
        put '/api/users',
            headers: { 'access-token': @api_key[:access_token] },
            params: { user: {
              name: nil,
              school: nil,
              login_id: nil,
              password: nil,
              password_confirmation: nil
            } }
        expect(response.status).to eq(422)
      end
    end

    it '未ログインユーザー' do
      put '/api/users'
      expect(response.status).to eq(401)
    end
  end
end
