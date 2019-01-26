# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Auth', type: :request do
  let!(:user) { create(:user) }

  describe 'index action' do
    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/auth'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(user)
        auth_params = get_auth_params(response)
        get '/api/auth', headers: auth_params
      end

      it 'status: 200' do
        expect(response.status).to eq(200)
      end

      it 'json の検証' do
        json = JSON.parse(response.body)
        expect(json['token']).not_to eq(nil)
        expect(json['expired_at']).not_to eq(nil)
        expect(json['user']['id']).to eq(user[:id])
        expect(json['user']['role']).to eq(user[:role])
      end
    end
  end

  describe 'create action' do
    context '有効なパラメータの場合' do
      before do
        post '/api/auth', params: valid_params
      end

      it 'status: 200' do
        expect(response.status).to eq(200)
      end

      it 'json の検証' do
        json = JSON.parse(response.body)
        expect(json['token']).not_to eq(nil)
        expect(json['expired_at']).not_to eq(nil)
        expect(json['user']['id']).to eq(user[:id])
        expect(json['user']['role']).to eq(user[:role])
      end
    end

    context '無効なパラメータの場合' do
      it 'status: 401' do
        post '/api/auth', params: login_id_nil_params
        expect(response.status).to eq(401)
        post '/api/auth', params: password_nil_params
        expect(response.status).to eq(401)
      end
    end
  end

  def valid_params
    {
      login_id: user[:login_id],
      password: '12345678'
    }
  end

  def login_id_nil_params
    {
      login_id: nil,
      password: '12345678'
    }
  end

  def password_nil_params
    {
      login_id: user[:login_id],
      password: nil
    }
  end
end
# rubocop:enable all
