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

  describe 'update_me action' do
    context '未ログインの場合' do
      it 'status: 401' do
        patch '/api/users/me'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(user)
        @auth_params = get_auth_params(response)
      end

      context '有効なパラメータの場合' do
        before do
          @size = User.all.size
          patch '/api/users/me', params: valid_params, headers: @auth_params
        end

        it 'status: 201' do
          expect(response.status).to eq(200)
        end

        it 'json を検証' do
          json = JSON.parse(response.body)
          expect(json['id']).to eq(user[:id])
          expect(json['name']).to eq(user[:name])
          expect(json['school']).to eq(user[:school])
          expect(json['role']).to eq(user[:role])
          expect(json['created_at']).to eq(default_time(user[:created_at]))
          expect(json['updated_at']).to eq(default_time(user[:updated_at]))
        end

        it 'size: 同じ' do
          expect(User.all.size).to eq(@size)
        end
      end

      context '無効なパラメータの場合' do
        it 'status: 400' do
          patch '/api/users/me',
                params: login_id_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          patch '/api/users/me',
                params: name_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          patch '/api/users/me',
                params: school_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          patch '/api/users/me',
                params: login_id_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
          patch '/api/users/me',
                params: name_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
          patch '/api/users/me',
                params: school_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
          patch '/api/users/me',
                params: login_id_format_params, headers: @auth_params
          expect(response.status).to eq(400)
          patch '/api/users/me',
                params: name_format_params, headers: @auth_params
          expect(response.status).to eq(400)
          patch '/api/users/me',
                params: school_format_params, headers: @auth_params
          expect(response.status).to eq(400)
          patch '/api/users/me',
                params: login_id_unique_params, headers: @auth_params
          expect(response.status).to eq(400)
        end
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
            post '/api/users/check_unique', headers: @auth_params, params: logged_in_user_my_login_id_params
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
            post '/api/users/check_unique', headers: @auth_params, params: logged_in_user_valid_params
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
          post '/api/users/check_unique', headers: @auth_params, params: logged_in_user_invalid_params
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

  def valid_params
    {
      user: {
        login_id: user[:login_id],
        name: user[:name],
        school: user[:school]
      }
    }
  end

  def login_id_nil_params
    {
      user: {
          login_id: nil,
          name: user[:name],
          school: user[:school]
      }
    }
  end

  def name_nil_params
    {
      user: {
        login_id: user[:login_id],
        name: nil,
        school: user[:school]
      }
    }
  end

  def school_nil_params
    {
      user: {
        login_id: user[:login_id],
        name: user[:name],
        school: nil
      }
    }
  end

  def login_id_max_length_params
    {
      user: {
        login_id: 'a' * 32,
        name: user[:name],
        school: user[:school]
      }
    }
  end

  def name_max_length_params
    {
      user: {
        login_id: user[:login_id],
        name: 'a' * 64,
        school: user[:school]
      }
    }
  end

  def school_max_length_params
    {
      user: {
        login_id: user[:login_id],
        name: user[:name],
        school: 'a' * 64
      }
    }
  end

  def login_id_format_params
    {
      user: {
        login_id: '!#$-%&@*/',
        name: user[:name],
        school: user[:school]
      }
    }
  end

  def name_format_params
    {
      user: {
        login_id: user[:login_id],
        name: '!#$-%&@*/',
        school: user[:school]
      }
    }
  end

  def school_format_params
    {
      user: {
        login_id: user[:login_id],
        name: user[:name],
        school: '!#$-%&@*/'
      }
    }
  end

  def login_id_unique_params
    {
      user: {
        login_id: created_user[:login_id],
        name: user[:name],
        school: user[:school]
      }
    }
  end
end
# rubocop:enable all
