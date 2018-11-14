require 'rails_helper'

RSpec.describe 'Teachers/Students', type: :request do
  before do
    @teacher = create(:teacher)
    @api_key = @teacher.activate
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
  end

  describe '講師以外に対するテスト' do
    before do
      @student = create(:student)
      @api_key = @student.activate
    end

    it '#create 401' do
      post '/api/teachers/students'
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン講師に対するテスト' do
    it '#create 401' do
      post '/api/teachers/students'
      expect(response.status).to eq(401)
    end
  end
end
