require 'rails_helper'

RSpec.describe 'Teachers/Teachers', type: :request do
  before do
    @user = build(:user)
    @teacher = create(:teacher)
    @api_key = @teacher.activate
  end

  describe '正しい講師に対するテスト' do
    describe 'POST /api/teachers/teachers' do
      it '新規講師登録 OK' do
        post '/api/teachers/teachers',
             headers: { 'access-token': @api_key[:access_token] },
             params: { user: {
               name: @user[:name],
               school: @user[:school],
               login_id: @user[:login_id],
               password: '12345678',
               password_confirmation: '12345678'
             } }
        expect(response.status).to eq(200)
        # roleの値の確認 (講師の初期権限: 1)
        json = JSON.parse(response.body)
        expect(json['user']['role']).to eq(1)
      end

      it '新規講師登録 NG' do
        post '/api/teachers/teachers',
             headers: { 'access-token': @api_key[:access_token] },
             params: { user: {
               name: @user[:name],
               school: @user[:school],
               login_id: @user[:login_id],
               password: nil,
               password_confirmation: nil
             } }
        expect(response.status).to eq(422)
      end
    end

    describe 'GET /api/teachers/teachers/:id/edit' do
      it '講師編集 取得' do
        get '/api/teachers/teachers/' + @teacher[:id].to_s + '/edit',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
      end
    end

    describe 'PUT /api/teachers/teachers/:id' do
      it '講師編集 OK' do
        put '/api/teachers/teachers/' + @teacher[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] },
            params: { user: {
              name: @user[:name],
              school: @user[:school],
              login_id: @user[:login_id],
              password: '12345678',
              password_confirmation: '12345678'
            } }
        expect(response.status).to eq(200)
        # roleの値の確認 (講師の初期権限: 1)
        json = JSON.parse(response.body)
        expect(json['user']['role']).to eq(1)
      end

      it '講師編集 NG' do
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

  describe '正しくない講師以外に対するテスト' do
    before do
      @other_teacher = create(:teacher)
      @other_api_key = @other_teacher.activate
    end

    it '講師編集 取得 NG' do
      get '/api/teachers/teachers/' + @teacher[:id].to_s + '/edit',
          headers: { 'access-token': @other_api_key[:access_token] }
      expect(response.status).to eq(403)
    end

    it '講師編集 NG' do
      put '/api/teachers/teachers/' + @teacher[:id].to_s,
          headers: { 'access-token': @other_api_key[:access_token] }
      expect(response.status).to eq(403)
    end
  end

  describe '講師以外に対するテスト' do
    before do
      @student = create(:student)
      @student_api_key = @student.activate
    end

    it '講師一覧 取得 NG' do
      get '/api/teachers/teachers',
          headers: { 'access-token': @student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '講師詳細 取得 NG' do
      get '/api/teachers/teachers/' + @teacher[:id].to_s,
          headers: { 'access-token': @student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '新規講師登録 NG' do
      post '/api/teachers/teachers',
           headers: { 'access-token': @student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '講師編集 取得 NG' do
      get '/api/teachers/teachers/' + @teacher[:id].to_s + '/edit',
          headers: { 'access-token': @student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '講師編集 NG' do
      put '/api/teachers/teachers/' + @teacher[:id].to_s,
          headers: { 'access-token': @student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン講師に対するテスト' do
    it '講師一覧 取得 NG' do
      get '/api/teachers/teachers'
      expect(response.status).to eq(401)
    end

    it '講師詳細 取得 NG' do
      get '/api/teachers/teachers/' + @teacher[:id].to_s
      expect(response.status).to eq(401)
    end

    it '新規講師登録 NG' do
      post '/api/teachers/teachers'
      expect(response.status).to eq(401)
    end

    it '講師編集 取得 NG' do
      get '/api/teachers/teachers/' + @teacher[:id].to_s + '/edit'
      expect(response.status).to eq(401)
    end

    it '講師編集 NG' do
      put '/api/teachers/teachers/' + @teacher[:id].to_s
      expect(response.status).to eq(401)
    end
  end
end
