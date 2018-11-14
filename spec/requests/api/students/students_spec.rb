require 'rails_helper'

RSpec.describe 'Students/Students', type: :request do
  before do
    @student = create(:student)
    @api_key = @student.activate
  end

  describe '正しい生徒に対するテスト' do
    describe 'GET /api/students/students/:id' do
      it '#show 200' do
        get '/api/students/students/' + @student[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['user']['id']).to eq(@student[:id])
        expect(json['user']['login_id']).to eq(@student[:login_id])
        expect(json['user']['name']).to eq(@student[:name])
        expect(json['user']['school']).to eq(@student[:school])
        expect(json['user']['role']).to eq(nil)
        expect(json['user']['encrypted_password']).to eq(nil)
        expect(json['user']['salt']).to eq(nil)
      end
    end

    describe 'GET /api/students/students/:id/edit' do
      it '#edit 200' do
        get '/api/students/students/' + @student[:id].to_s + '/edit',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
      end
    end

    describe 'PUT /api/students/students/:id' do
      let!(:user) { build(:student) }

      it '#update 200' do
        count = User.count
        put '/api/students/students/' + @student[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] },
            params: { user: {
              name: user[:name],
              school: user[:school],
              login_id: user[:login_id],
              password: '12345678',
              password_confirmation: '12345678'
            } }
        expect(response.status).to eq(200)
        expect(User.count).to eq(count)
      end

      it '#update 422' do
        put '/api/students/students/' + @student[:id].to_s,
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

  describe '正しくない生徒に対するテスト' do
    let!(:other_student) { create(:student) }
    let!(:other_student_api_key) { other_student.activate }

    it '#show 403' do
      get '/api/students/students/' + @student[:id].to_s,
          headers: { 'access-token': other_student_api_key[:access_token] }
      expect(response.status).to eq(403)
    end

    it '#edit 403' do
      get '/api/students/students/' + @student[:id].to_s + '/edit',
          headers: { 'access-token': other_student_api_key[:access_token] }
      expect(response.status).to eq(403)
    end

    it '#update 403' do
      put '/api/students/students/' + @student[:id].to_s,
          headers: { 'access-token': other_student_api_key[:access_token] }
      expect(response.status).to eq(403)
    end
  end

  describe '生徒以外に対するテスト' do
    let!(:teacher) { create(:teacher) }
    let!(:teacher_api_key) { teacher.activate }

    it '#show 403' do
      get '/api/students/students/' + @student[:id].to_s,
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(403)
    end

    it '#edit 403' do
      get '/api/students/students/' + @student[:id].to_s + '/edit',
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(403)
    end

    it '#update 403' do
      put '/api/students/students/' + @student[:id].to_s,
          headers: { 'access-token': teacher_api_key[:access_token] }
      expect(response.status).to eq(403)
    end
  end

  describe '未ログイン生徒に対するテスト' do
    it '#show 401' do
      get '/api/students/students/' + @student[:id].to_s
      expect(response.status).to eq(401)
    end

    it '#edit 401' do
      get '/api/students/students/' + @student[:id].to_s + '/edit'
      expect(response.status).to eq(401)
    end

    it '#update 401' do
      put '/api/students/students/' + @student[:id].to_s
      expect(response.status).to eq(401)
    end
  end
end
