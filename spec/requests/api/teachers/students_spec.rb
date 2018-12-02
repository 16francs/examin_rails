require 'rails_helper'

RSpec.describe 'Teachers/Students', type: :request do
  before do
    @admin = create(:admin)
    @api_key = @admin.activate
  end

  describe '正しい講師に対するテスト' do
    describe 'GET /api/teachers/students' do
      let!(:user) { create(:student) }

      it '#index 200' do
        get '/api/teachers/students',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['users'][0]['id']).to_not eq(nil)
        expect(json['users'][0]['login_id']).to_not eq(nil)
        expect(json['users'][0]['name']).to_not eq(nil)
        expect(json['users'][0]['school']).to_not eq(nil)
        expect(json['users'][0]['role']).to_not eq(nil)
        expect(json['users'][0]['created_at']).to_not eq(nil)
        expect(json['users'][0]['updated_at']).to_not eq(nil)
        expect(json['users'][0]['encrypted_password']).to eq(nil)
        expect(json['users'][0]['salt']).to eq(nil)
      end
    end

    describe 'GET /api/teachers/students/:id' do
      let!(:user) { create(:student) }

      it '#show 200' do
        get '/api/teachers/students/' + user[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['user']['id']).to eq(user[:id])
        expect(json['user']['login_id']).to eq(user[:login_id])
        expect(json['user']['name']).to eq(user[:name])
        expect(json['user']['school']).to eq(user[:school])
        expect(json['user']['role']).to eq(user[:role])
        expect(json['user']['created_at']).to_not eq(nil)
        expect(json['user']['updated_at']).to_not eq(nil)
        expect(json['user']['encrypted_password']).to eq(nil)
        expect(json['user']['salt']).to eq(nil)
      end

      it '#show 404' do
        get '/api/teachers/students/0',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(404)
      end
    end

    describe 'POST /api/teachers/students' do
      let!(:user) { build(:student) }

      it '#create 200' do
        count = User.count
        post '/api/teachers/students',
             headers: { 'access-token': @api_key[:access_token] },
             params: { user: {
               name: user[:name],
               school: user[:school],
               login_id: user[:login_id],
               password: '12345678',
               password_confirmation: '12345678'
             } }
        expect(response.status).to eq(200)
        expect(User.count).to eq(count + 1)
        # roleの値の確認 (生徒の初期権限: 0)
        json = JSON.parse(response.body)
        expect(json['user']['role']).to eq(0)
      end

      it '#create 422' do
        post '/api/teachers/students',
             headers: { 'access-token': @api_key[:access_token] },
             params: { user: {
               name: user[:name],
               school: user[:school],
               login_id: user[:login_id],
               password: nil,
               password_confirmation: nil
             } }
        expect(response.status).to eq(422)
      end
    end

    describe 'GET /api/teachers/students/:id/edit' do
      let!(:user) { create(:student) }

      it '#edit 200' do
        get '/api/teachers/students/' + user[:id].to_s + '/edit',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
      end

      it '#edit 404' do
        get '/api/teachers/students/0/edit',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(404)
      end
    end

    describe 'PUT /api/teachers/students/:id' do
      let!(:student) { create(:student) }
      let!(:user) { build(:user) }

      it '#update 200' do
        put '/api/teachers/students/' + student[:id].to_s,
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

      it '#update 404' do
        put '/api/teachers/students/0',
            headers: { 'access-token': @api_key[:access_token] },
            params: { user: {
              name: nil,
              school: nil,
              login_id: nil,
              password: nil,
              password_confirmation: nil
            } }
        expect(response.status).to eq(404)
      end

      it '#update 422' do
        put '/api/teachers/students/' + student[:id].to_s,
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
  end

  describe '管理者以外に対するテスト' do
    let!(:teacher) { create(:teacher) }
    let!(:teacher_api_key) { teacher.activate }

    it '#create 401' do
      post '/api/teachers/students/',
           headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(403)
    end

    it '#edit 401' do
      get '/api/teachers/students/0/edit',
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(403)
    end

    it '#update 401' do
      put '/api/teachers/students/0',
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(403)
    end
  end

  describe '講師以外に対するテスト' do
    let!(:student) { create(:student) }
    let!(:student_api_key) { student.activate }

    it '#index 401' do
      get '/api/teachers/students',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/teachers/students/0',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#create 401' do
      post '/api/teachers/students',
           headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#edit 401' do
      get '/api/teachers/students/0/edit',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#update 401' do
      put '/api/teachers/students/0',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン講師に対するテスト' do
    it '#index 401' do
      get '/api/teachers/students'
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/teachers/students/0'
      expect(response.status).to eq(401)
    end

    it '#create 401' do
      post '/api/teachers/students'
      expect(response.status).to eq(401)
    end

    it '#edit 401' do
      get '/api/teachers/students/0/edit'
      expect(response.status).to eq(401)
    end

    it '#update 401' do
      put '/api/teachers/students/0'
      expect(response.status).to eq(401)
    end
  end
end
