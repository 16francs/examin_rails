# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Teachers::Students', type: :request do
  let!(:admin) { create(:admin) }
  let!(:student) { build(:student) }
  let!(:other_student) { create(:student) }

  describe 'create action' do
    context '未ログインの場合' do
      it 'status: 401' do
        post '/api/teachers/students'
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
          post '/api/teachers/students', params: valid_params, headers: @auth_params
          expect(response.status).to eq(200)
        end
      end

      context '無効なパラメータの場合' do
        it 'status: 422' do
          post '/api/teachers/students',
               params: login_id_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: name_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: school_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: password_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: password_confirmation_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: login_id_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: name_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: school_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: password_min_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: password_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: password_confirmation_min_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: password_confirmation_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: login_id_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: name_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: school_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: password_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: password_confirmation_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: login_id_unique_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/students',
               params: invalid_password_params, headers: @auth_params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  def valid_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def login_id_nil_params
    {
      student: {
        login_id: nil,
        name: student[:name],
        school: student[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def name_nil_params
    {
      student: {
        login_id: student[:login_id],
        name: nil,
        school: student[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def school_nil_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: nil,
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def password_nil_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school],
        password: nil,
        password_confirmation: '12345678'
      }
    }
  end

  def password_confirmation_nil_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school],
        password: '12345678',
        password_confirmation: nil
      }
    }
  end

  def login_id_max_length_params
    {
      student: {
        login_id: 'a' * 32,
        name: student[:name],
        school: student[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def name_max_length_params
    {
      student: {
        login_id: student[:login_id],
        name: 'a' * 64,
        school: student[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def school_max_length_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: 'a' * 64,
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def password_min_length_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school],
        password: 'a' * 7,
        password_confirmation: '12345678'
      }
    }
  end

  def password_max_length_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school],
        password: 'a' * 16,
        password_confirmation: '12345678'
      }
    }
  end

  def password_confirmation_min_length_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school],
        password: '12345678',
        password_confirmation: 'a' * 7
      }
    }
  end

  def password_confirmation_max_length_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school],
        password: '12345678',
        password_confirmation: 'a' * 16
      }
    }
  end

  def login_id_format_params
    {
      student: {
        login_id: '!#$-%&@*/',
        name: student[:name],
        school: student[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def name_format_params
    {
      student: {
        login_id: student[:login_id],
        name: '!#$-%&@*/',
        school: student[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def school_format_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: '!#$-%&@*/',
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def password_format_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school],
        password: '!#$%&@*/',
        password_confirmation: '12345678'
      }
    }
  end

  def password_confirmation_format_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school],
        password: '12345678',
        password_confirmation: '!#$-%&@*/'
      }
    }
  end

  def login_id_unique_params
    {
      student: {
        login_id: other_student[:login_id],
        name: student[:name],
        school: student[:school],
        password: '12345678',
        password_confirmation: '12345678'
      }
    }
  end

  def invalid_password_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school],
        password: '12345678',
        password_confirmation: '87654321'
      }
    }
  end
end
# rubocop:enable all
