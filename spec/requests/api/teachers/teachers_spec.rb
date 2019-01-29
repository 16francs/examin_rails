# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Teachers::Teachers', type: :request do
  let!(:admin) { create(:admin) }
  let!(:teacher) { build(:teacher) }
  let!(:other_teacher) { create(:teacher) }

  describe 'create action' do
    context '未ログインの場合' do
      it 'status: 401' do
        post '/api/teachers/teachers'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(admin)
        @auth_params = get_auth_params(response)
      end

      context '有効なパラメータの場合' do
        it 'status: 200' do
          post '/api/teachers/teachers', params: valid_params, headers: @auth_params
          expect(response.status).to eq(200)
        end
      end

      context '無効なパラメータの場合' do
        it 'status: 422' do
          post '/api/teachers/teachers',
               params: login_id_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: name_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: school_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: password_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: password_confirmation_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: login_id_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: name_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: school_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: password_min_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: password_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: password_confirmation_min_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: password_confirmation_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: login_id_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: name_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: school_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: password_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: password_confirmation_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: login_id_unique_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/teachers',
               params: invalid_password_params, headers: @auth_params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  def valid_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def login_id_nil_params
    {
      teacher: {
        login_id: nil,
        name: teacher[:name],
        school: teacher[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def name_nil_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: nil,
        school: teacher[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def school_nil_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: nil,
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def password_nil_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: nil,
        password_confirmation: '12345678'
      }
    }
  end

  def password_confirmation_nil_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: '12345678',
        password_confirmation: nil
      }
    }
  end

  def login_id_max_length_params
    {
      teacher: {
        login_id: 'a' * 32,
        name: teacher[:name],
        school: teacher[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def name_max_length_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: 'a' * 64,
        school: teacher[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def school_max_length_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: 'a' * 64,
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def password_min_length_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: 'a' * 7,
        password_confirmation: '12345678'
      }
    }
  end

  def password_max_length_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: 'a' * 16,
        password_confirmation: '12345678'
      }
    }
  end

  def password_confirmation_min_length_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: '12345678',
        password_confirmation: 'a' * 7
      }
    }
  end

  def password_confirmation_max_length_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: '12345678',
        password_confirmation: 'a' * 16
      }
    }
  end

  def login_id_format_params
    {
      teacher: {
        login_id: '!#$-%&@*/',
        name: teacher[:name],
        school: teacher[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def name_format_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: '!#$-%&@*/',
        school: teacher[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def school_format_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: '!#$-%&@*/',
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def password_format_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: '!#$%&@*/',
        password_confirmation: '12345678'
      }
    }
  end

  def password_confirmation_format_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: '12345678',
        password_confirmation: '!#$-%&@*/'
      }
    }
  end

  def login_id_unique_params
    {
      teacher: {
        login_id: other_teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def invalid_password_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school],
        password: '12345678',
        password_confirmation: '87654321'
      }
    }
  end
end
# rubocop:enable all
