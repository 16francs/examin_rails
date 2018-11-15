require 'rails_helper'

RSpec.describe 'Teachers/Problems', type: :request do
  before do
    @teacher = create(:teacher)
    @api_key = @teacher.activate
  end

  describe '正しい講師に対するテスト' do
    describe 'GET /api/teachers/problems' do
      let!(:problem) { create(:problem, :with_user) }

      it '#index 200' do
        get '/api/teachers/problems',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['problems'][0]['id']).to_not eq(nil)
        expect(json['problems'][0]['title']).to_not eq(nil)
        expect(json['problems'][0]['content']).to_not eq(nil)
        expect(json['problems'][0]['user_id']).to_not eq(nil)
        expect(json['problems'][0]['created_at']).to_not eq(nil)
        expect(json['problems'][0]['updated_at']).to_not eq(nil)
      end
    end

    describe 'GET /api/teachers/problems/:id' do
      let!(:problem) { create(:problem, :with_user) }

      it '#show 200' do
        get '/api/teachers/problems/' + problem[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
        # jsonの検証
        json = JSON.parse(response.body)
        expect(json['problem']['id']).to_not eq(nil)
        expect(json['problem']['title']).to_not eq(nil)
        expect(json['problem']['content']).to_not eq(nil)
        expect(json['problem']['user_id']).to_not eq(nil)
        expect(json['problem']['created_at']).to_not eq(nil)
        expect(json['problem']['updated_at']).to_not eq(nil)
      end

      it '#show 404' do
        get '/api/teachers/problems/0',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(404)
      end
    end

    describe 'POST /api/teachers/problems' do
      let!(:problem) { build(:problem, :with_user) }

      it '#create 200' do
        count = Problem.count
        post '/api/teachers/problems',
             headers: { 'access-token': @api_key[:access_token] },
             params: { problem: {
               title: problem[:title],
               content: problem[:content]
             } }
        expect(response.status).to eq(200)
        expect(Problem.count).to eq(count + 1)
        # user_idの値の確認 (user_id: current_user)
        json = JSON.parse(response.body)
        expect(json['problem']['user_id']).to eq(@teacher[:id])
      end

      it '#createa 422' do
        post '/api/teachers/problems',
             headers: { 'access-token': @api_key[:access_token] },
             params: { problem: {
               title: nil,
               content: nil
             } }
        expect(response.status).to eq(422)
      end
    end

    describe 'GET /api/teachers/problems/:id/edit' do
      let!(:problem) { create(:problem, :with_user) }

      it '#edit 200' do
        get '/api/teachers/problems/' + problem[:id].to_s + '/edit',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(200)
      end

      it '#edit 404' do
        get '/api/teachers/problems/0/edit',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(404)
      end
    end

    describe 'PUT /api/teachers/problems/:id' do
      let!(:problem) { create(:problem, :with_user) }

      it '#update 200' do
        put '/api/teachers/problems/' + problem[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] },
            params: { problem: {
              title: problem[:user_id],
              content: problem[:user_id]
            } }
        expect(response.status).to eq(200)
        # user_idの値の確認 (user_id: current_user)
        json = JSON.parse(response.body)
        expect(json['problem']['user_id']).to eq(@teacher[:id])
      end

      it '#update 404' do
        put '/api/teachers/problems/0',
            headers: { 'access-token': @api_key[:access_token] }
        expect(response.status).to eq(404)
      end

      it '#udpate 422' do
        put '/api/teachers/problems/' + problem[:id].to_s,
            headers: { 'access-token': @api_key[:access_token] },
            params: { problem: {
                title: nil,
                content: nil
            } }
        expect(response.status).to eq(422)
      end
    end
  end

  describe '講師以外に対するテスト' do
    let!(:student) { create(:student) }
    let!(:student_api_key) { student.activate }

    it '#index 401' do
      get '/api/teachers/problems',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#create 401' do
      post '/api/teachers/problems',
           headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#edit 401' do
      get '/api/teachers/problems/0/edit',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end

    it '#update 401' do
      put '/api/teachers/problems/0',
          headers: { 'access-token': student_api_key[:access_token] }
      expect(response.status).to eq(401)
    end
  end

  describe '未ログイン講師に対するテスト' do
    it '#index 401' do
      get '/api/teachers/problems'
      expect(response.status).to eq(401)
    end

    it '#create 401' do
      post '/api/teachers/problems'
      expect(response.status).to eq(401)
    end

    it '#edit 401' do
      get '/api/teachers/problems/0/edit'
      expect(response.status).to eq(401)
    end

    it '#update 401' do
      put '/api/teachers/problems/0'
      expect(response.status).to eq(401)
    end
  end
end
