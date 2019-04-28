# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Teachers::Teachers', type: :request do
  let!(:admin) { create(:admin) }
  let!(:teacher) { build(:teacher) }

  describe 'index action' do
    let(:teachers) { create_list(:teacher, 10) }

    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/teachers/teachers'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(admin)
        auth_params = get_auth_params(response)
        get '/api/teachers/teachers', headers: auth_params
      end

      it 'status: 200' do
        expect(response.status).to eq(200)
      end

      it 'json の検証' do
        json = JSON.parse(response.body)
        teachers.map(&:reload)
        expect(json['teachers'][0]['id']).to eq(admin[:id])
        expect(json['teachers'][0]['name']).to eq(admin[:name])
        expect(json['teachers'][0]['school']).to eq(admin[:school])
        expect(json['teachers'][0]['role']).to eq(admin[:role])
        expect(json['teachers'][0]['login_id']).to eq(admin[:login_id])
      end
    end
  end

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
        before do
          @size = User.all.size
          post '/api/teachers/teachers', params: valid_params, headers: @auth_params
        end

        it 'status: 201' do
          expect(response.status).to eq(201)
        end

        it 'json を検証' do
          json = JSON.parse(response.body)
          teacher = User.last
          expect(json['id']).to eq(teacher[:id])
          expect(json['name']).to eq(teacher[:name])
          expect(json['school']).to eq(teacher[:school])
          expect(json['role']).to eq(teacher[:role])
          expect(json['login_id']).to eq(teacher[:login_id])
          expect(json['created_at']).to eq(default_time(teacher[:created_at]))
          expect(json['updated_at']).to eq(default_time(teacher[:updated_at]))
        end

        it 'size: +1' do
          expect(User.all.size).to eq(@size + 1)
        end
      end

      context '無効なパラメータの場合' do
        let!(:other_teacher) { create(:teacher) }

        it 'status: 400' do
          post '/api/teachers/teachers',
               params: login_id_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/teachers',
               params: name_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/teachers',
               params: school_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/teachers',
               params: login_id_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/teachers',
               params: name_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/teachers',
               params: school_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/teachers',
               params: login_id_format_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/teachers',
               params: name_format_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/teachers',
               params: school_format_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/teachers',
               params: login_id_unique_params, headers: @auth_params
          expect(response.status).to eq(400)
        end

        def login_id_unique_params
          {
            teacher: {
              login_id: other_teacher[:login_id],
              name: teacher[:name],
              school: teacher[:school]
            }
          }
        end
      end
    end
  end

  def valid_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: teacher[:school]
      }
    }
  end

  def login_id_nil_params
    {
      teacher: {
        login_id: nil,
        name: teacher[:name],
        school: teacher[:school]
      }
    }
  end

  def name_nil_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: nil,
        school: teacher[:school]
      }
    }
  end

  def school_nil_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: nil
      }
    }
  end

  def login_id_max_length_params
    {
      teacher: {
        login_id: 'a' * 32,
        name: teacher[:name],
        school: teacher[:school]
      }
    }
  end

  def name_max_length_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: 'a' * 64,
        school: teacher[:school]
      }
    }
  end

  def school_max_length_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: 'a' * 64
      }
    }
  end

  def login_id_format_params
    {
      teacher: {
        login_id: '!#$-%&@*/',
        name: teacher[:name],
        school: teacher[:school]
      }
    }
  end

  def name_format_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: '!#$-%&@*/',
        school: teacher[:school]
      }
    }
  end

  def school_format_params
    {
      teacher: {
        login_id: teacher[:login_id],
        name: teacher[:name],
        school: '!#$-%&@*/'
      }
    }
  end
end
# rubocop:enable all
