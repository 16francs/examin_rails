require 'rails_helper'

RSpec.describe 'Teachers/Teachers', type: :request do
  before do
    @teacher = create(:teacher)
    @api_key = @teacher.activate
  end

  describe '正しい講師に対するテスト' do
    describe 'POST /api/teachers/teachers/check_unique' do
      it '#check_unique OK' do
        post '/api/teachers/teachers/check_unique',
             headers: { 'access-token': @api_key[:access_token] },
             params: { login_id: nil }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['check_unique']).to eq(true)
      end

      it '#check_unique NG' do
        post '/api/teachers/teachers/check_unique',
             headers: { 'access-token': @api_key[:access_token] },
             params: { login_id: @teacher[:login_id] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['check_unique']).to eq(false)
      end
    end

    describe 'POST /api/teachers/teachers/:id/check/unique' do
      let!(:user) { create(:teacher) }

      describe '#check_unique OK' do
        it '編集箇所と同じ値' do
          post '/api/teachers/teachers/' + @teacher[:id].to_s + '/check_unique',
               headers: { 'access-token': @api_key[:access_token] },
               params: { login_id: @teacher[:login_id] }
          expect(response.status).to eq(200)
          # jsonの検証
          json = JSON.parse(response.body)
          expect(json['check_unique']).to eq(true)
        end

        it '編集箇所と違う値' do
          post '/api/teachers/teachers/' + @teacher[:id].to_s + '/check_unique',
               headers: { 'access-token': @api_key[:access_token] },
               params: { login_id: '' }
          expect(response.status).to eq(200)
          # jsonの検証
          json = JSON.parse(response.body)
          expect(json['check_unique']).to eq(true)
        end
      end

      it '#check_unique NG' do
        post '/api/teachers/teachers/' + @teacher[:id].to_s + '/check_unique',
             headers: { 'access-token': @api_key[:access_token] },
             params: { login_id: user[:login_id] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['check_unique']).to eq(false)
      end
    end

    describe 'GET /api/teachers/teachers' do
      let!(:user) { create(:teacher) }

      it '#index 200' do
        get '/api/teachers/teachers/',
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

    describe 'GET /api/teachers/teachers/:id' do
      let!(:user) { create(:teacher) }

      it '#show 200' do
        get '/api/teachers/teachers/' + user[:id].to_s,
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
        get '/api/teachers/teachers/0',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(404)
      end
    end

    describe 'POST /api/teachers/teachers' do
      let!(:user) { build(:teacher) }

      it '#create 200' do
        count = User.count
        post '/api/teachers/teachers',
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
        # roleの値の確認 (講師の初期権限: 1)
        json = JSON.parse(response.body)
        expect(json['user']['role']).to eq(1)
      end

      it '#create #422' do
        post '/api/teachers/teachers',
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

    describe 'GET /api/teachers/teachers/:id/edit' do
      it '#edit 200' do
        get '/api/teachers/teachers/' + @teacher[:id].to_s + '/edit',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
      end
    end

    describe 'PUT /api/teachers/teachers/:id' do
      let!(:user) { build(:teacher) }

      it '#update 200' do
        count = User.count
        put '/api/teachers/teachers/' + @teacher[:id].to_s,
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
        # roleの値の確認 (講師の初期権限: 1)
        json = JSON.parse(response.body)
        expect(json['user']['role']).to eq(@teacher[:role])
      end

      it '#update 422' do
        put '/api/teachers/teachers/' + @teacher[:id].to_s,
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

  describe '正しくない講師に対するテスト' do
    let!(:other_teacher) { create(:teacher) }
    let!(:other_teacher_api_key) { other_teacher.activate }

    it '#edit 403' do
      get '/api/teachers/teachers/' + @teacher[:id].to_s + '/edit',
          headers: { 'access-token': other_teacher_api_key[:access_token] }
      expect(response.status).to eq(403)
    end

    it '#update 403' do
      put '/api/teachers/teachers/' + @teacher[:id].to_s,
          headers: { 'access-token': other_teacher_api_key[:access_token] }
      expect(response.status).to eq(403)
    end
  end

  describe '講師以外に対するテスト' do
    let!(:student) { create(:student) }
    let!(:student_api_key) { student.activate }

    it '#check_unique 401' do
      post '/api/teachers/teachers/check_unique',
           headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)

      post '/api/teachers/teachers/0/check_unique',
           headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#index 401' do
      get '/api/teachers/teachers',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/teachers/teachers/0',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#create 401' do
      post '/api/teachers/teachers',
           headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#edit 401' do
      get '/api/teachers/teachers/0/edit',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#update 401' do
      put '/api/teachers/teachers/0',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン講師に対するテスト' do
    it '#check_unique 401' do
      post '/api/teachers/teachers/check_unique'
      expect(response.status).to eq(401)

      post '/api/teachers/teachers/0/check_unique'
      expect(response.status).to eq(401)
    end

    it '#index 401' do
      get '/api/teachers/teachers'
      expect(response.status).to eq(401)
    end

    it '#show 401' do
      get '/api/teachers/teachers/0'
      expect(response.status).to eq(401)
    end

    it '#create 401' do
      post '/api/teachers/teachers'
      expect(response.status).to eq(401)
    end

    it '#edit 401' do
      get '/api/teachers/teachers/0/edit'
      expect(response.status).to eq(401)
    end

    it '#update 401' do
      put '/api/teachers/teachers/0'
      expect(response.status).to eq(401)
    end
  end
end
