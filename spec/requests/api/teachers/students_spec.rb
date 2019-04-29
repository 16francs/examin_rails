# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Teachers::Students', type: :request do
  let!(:admin) { create(:admin) }
  let!(:student) { build(:student) }
  let!(:other_student) { create(:student) }

  describe 'index action' do
    let(:students) { create_list(:student, 10) }

    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/teachers/students'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(admin)
        auth_params = get_auth_params(response)
        get '/api/teachers/students', headers: auth_params
      end

      it 'status: 200' do
        expect(response.status).to eq(200)
      end

      it 'json の検証' do
        json = JSON.parse(response.body)
        students.map(&:reload)
        expect(json['students'][0]['id']).to eq(other_student[:id])
        expect(json['students'][0]['name']).to eq(other_student[:name])
        expect(json['students'][0]['school']).to eq(other_student[:school])
        expect(json['students'][0]['role']).to eq(other_student[:role])
        expect(json['students'][0]['login_id']).to eq(other_student[:login_id])
      end
    end
  end

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
        before do
          @size = User.all.size
          post '/api/teachers/students', params: valid_params, headers: @auth_params
        end

        it 'status: 201' do
          expect(response.status).to eq(201)
        end

        it 'json を検証' do
          json = JSON.parse(response.body)
          student = User.last
          expect(json['id']).to eq(student[:id])
          expect(json['name']).to eq(student[:name])
          expect(json['school']).to eq(student[:school])
          expect(json['role']).to eq(student[:role])
          expect(json['created_at']).to eq(default_time(student[:created_at]))
          expect(json['updated_at']).to eq(default_time(student[:updated_at]))
        end

        it 'size: +1' do
          expect(User.all.size).to eq(@size + 1)
        end
      end

      context '無効なパラメータの場合' do
        it 'status: 400' do
          post '/api/teachers/students',
               params: login_id_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/students',
               params: name_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/students',
               params: school_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/students',
               params: login_id_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/students',
               params: name_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/students',
               params: school_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/students',
               params: login_id_format_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/students',
               params: name_format_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/students',
               params: school_format_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/students',
               params: login_id_unique_params, headers: @auth_params
          expect(response.status).to eq(400)
        end

        def login_id_unique_params
          {
            student: {
              login_id: other_student[:login_id],
              name: student[:name],
              school: student[:school]
            }
          }
        end
      end
    end
  end

  def valid_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: student[:school]
      }
    }
  end

  def login_id_nil_params
    {
      student: {
        login_id: nil,
        name: student[:name],
        school: student[:school]
      }
    }
  end

  def name_nil_params
    {
      student: {
        login_id: student[:login_id],
        name: nil,
        school: student[:school]
      }
    }
  end

  def school_nil_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: nil
      }
    }
  end

  def login_id_max_length_params
    {
      student: {
        login_id: 'a' * 32,
        name: student[:name],
        school: student[:school]
      }
    }
  end

  def name_max_length_params
    {
      student: {
        login_id: student[:login_id],
        name: 'a' * 64,
        school: student[:school]
      }
    }
  end

  def school_max_length_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: 'a' * 64
      }
    }
  end

  def login_id_format_params
    {
      student: {
        login_id: '!#$-%&@*/',
        name: student[:name],
        school: student[:school]
      }
    }
  end

  def name_format_params
    {
      student: {
        login_id: student[:login_id],
        name: '!#$-%&@*/',
        school: student[:school]
      }
    }
  end

  def school_format_params
    {
      student: {
        login_id: student[:login_id],
        name: student[:name],
        school: '!#$-%&@*/'
      }
    }
  end
end
# rubocop:enable all
