# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Users', type: :request do
  let!(:user) { create(:user) }
  let!(:created_user) { create(:user) }
  let!(:not_created_user) { build(:user) }

  describe 'show_me action' do
    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/users/me'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(user)
        auth_params = get_auth_params(response)
        get '/api/users/me', headers: auth_params
      end

      it 'status: 200' do
        expect(response.status).to eq(200)
      end

      it 'json の検証' do
        json = JSON.parse(response.body)
        user.reload
        
        expect(json['id']).to eq(user[:id])
        expect(json['login_id']).to eq(user[:login_id])
        expect(json['name']).to eq(user[:name])
        expect(json['school']).to eq(user[:school])
        expect(json['role']).to eq(user[:role])
        expect(json['created_at']).to eq(default_time(user[:created_at]))
        expect(json['updated_at']).to eq(default_time(user[:updated_at]))
      end
    end
  end

  describe 'check_unique action' do
    context '未ログインの場合' do
      context '有効なパラメータの場合' do
        before do
          post '/api/users/check_unique', params: valid_check_unique_params
        end

        it 'status: 200' do
          expect(response.status).to eq(200)
        end

        it 'json を検証' do
          json = JSON.parse(response.body)
          expect(json['check_unique']).to eq(true)
        end
      end

      context '無効なパラメータの場合' do
        before do
          post '/api/users/check_unique', params: invalid_check_unique_params
        end

        it 'status: 200' do
          expect(response.status).to eq(200)
        end

        it 'json を検証' do
          json = JSON.parse(response.body)
          expect(json['check_unique']).to eq(false)
        end
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(user)
        @auth_params = get_auth_params(response)
      end

      context '有効なパラメータの場合' do
        context 'ログインユーザーの login_id と同じ場合' do
          before do
            post '/api/users/check_unique', headers: @auth_params,
                 params: logged_in_user_my_login_id_params
          end

          it 'status: 200' do
            expect(response.status).to eq(200)
          end

          it 'json を検証' do
            json = JSON.parse(response.body)
            expect(json['check_unique']).to eq(true)
          end
        end

        context 'ログインユーザーの login_id と違う場合' do
          before do
            post '/api/users/check_unique', headers: @auth_params,
                 params: logged_in_user_valid_params
          end

          it 'status: 200' do
            expect(response.status).to eq(200)
          end

          it 'json を検証' do
            json = JSON.parse(response.body)
            expect(json['check_unique']).to eq(true)
          end
        end
      end

      context '無効なパラメータの場合' do
        before do
          post '/api/users/check_unique', headers: @auth_params,
               params: logged_in_user_invalid_params
        end

        it 'status: 200' do
          expect(response.status).to eq(200)
        end

        it 'json を検証' do
          json = JSON.parse(response.body)
          expect(json['check_unique']).to eq(false)
        end
      end
    end
  end

  def valid_check_unique_params
    {
      user: {
        login_id: not_created_user[:login_id]
      }
    }
  end

  def invalid_check_unique_params
    {
      user: {
        login_id: created_user[:login_id]
      }
    }
  end

  def logged_in_user_valid_params
    {
      user: {
        id: user[:id],
        login_id: not_created_user[:login_id]
      }
    }
  end

  def logged_in_user_invalid_params
    {
      user: {
        id: user[:id],
        login_id: created_user[:login_id]
      }
    }
  end

  def logged_in_user_my_login_id_params
    {
      user: {
        id: user[:id],
        login_id: user[:login_id]
      }
    }
  end
end
# rubocop:enable all
