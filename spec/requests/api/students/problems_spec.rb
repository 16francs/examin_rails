# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Students::Problems', type: :request do
  let!(:student) { create(:student) }

  describe 'index action' do
    let!(:teacher) { create(:teacher) }
    let!(:problems) { create_list(:problem, 10, user: teacher) }

    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/students/problems'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(student)
        auth_params = get_auth_params(response)
        get '/api/students/problems', headers: auth_params
      end

      it 'status: 200' do
        expect(response.status).to eq(200)
      end

      it 'json の検証' do
        json = JSON.parse(response.body)
        problems.map(&:reload)
        expect(json['problems'][0]['id']).to eq(problems[0][:id])
        expect(json['problems'][0]['title']).to eq(problems[0][:title])
        expect(json['problems'][0]['content']).to eq(problems[0][:content])
        expect(json['problems'][0]['teacher_name']).to eq(problems[0].user[:name])
        expect(json['problems'][0]['created_at']).to eq(default_time(problems[0][:created_at]))
        expect(json['problems'][0]['updated_at']).to eq(default_time(problems[0][:updated_at]))
      end
    end
  end

  describe 'show action' do
    let!(:teacher) { create(:teacher) }
    let!(:problem) { create(:problem, user: teacher) }
    let!(:questions) { create_list(:question, 10, problem: problem) }

    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/students/problems/' + problem[:id].to_s
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(student)
        auth_params = get_auth_params(response)
        get '/api/students/problems/' + problem[:id].to_s, headers: auth_params
      end

      it 'status: 200' do
        expect(response.status).to eq(200)
      end

      it 'json の検証' do
        json = JSON.parse(response.body)
        problem.reload
        questions.map(&:reload)
        expect(json['id']).to eq(problem[:id])
        expect(json['title']).to eq(problem[:title])
        expect(json['user_id']).to eq(problem[:user_id])
        expect(json['created_at']).to eq(default_time(problem[:created_at]))
        expect(json['updated_at']).to eq(default_time(problem[:updated_at]))
        expect(json['questions'][0]['id']).to eq(questions[0][:id])
        expect(json['questions'][0]['sentence']).to eq(questions[0][:sentence])
        expect(json['questions'][0]['correct']).to eq(questions[0][:correct])
      end
    end
  end

  describe 'achievement action' do
    let!(:teacher) { create(:teacher) }
    let!(:problem) { create(:problem, user: teacher) }
    let!(:questions) { create_list(:question, 10, problem: problem) }

    context '未ログインの場合' do
      it 'status: 401' do
        post '/api/students/problems/' + problem[:id].to_s + '/achievement'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(student)
        @auth_params = get_auth_params(response)
      end

      context '有効なパラメータの場合' do
        before do
          @problems_user_size = ProblemsUser.all.size
          @achievement_size = Achievement.all.size
          post '/api/students/problems/' + problem[:id].to_s + '/achievement',
               headers: @auth_params, params: valid_params
        end

        it 'status: 201' do
          expect(response.status).to eq(201)
        end

        it 'json の検証' do
          json = JSON.parse(response.body)
          problems_user = ProblemsUser.last
          achievement = Achievement.last
          expect(json['id']).to eq(problems_user[:id])
          expect(json['problem_id']).to eq(problems_user[:problem_id])
          expect(json['user_id']).to eq(problems_user[:user_id])
          expect(json['created_at']).to eq(default_time(problems_user[:created_at]))
          expect(json['updated_at']).to eq(default_time(problems_user[:updated_at]))
          expect(json['achievements'][1]['id']).to eq(achievement[:id])
          expect(json['achievements'][1]['question_id']).to eq(achievement[:question_id])
          expect(json['achievements'][1]['result']).to eq(achievement[:result])
          expect(json['achievements'][1]['user_choice']).to eq(achievement[:user_choice])
        end

        it 'size: +1' do
          expect(ProblemsUser.all.size).to eq(@problems_user_size + 1)
          expect(Achievement.all.size).to eq(@achievement_size + 2)
        end
      end
    end

    def valid_params
      {
        achievements: [
          {
            question_id: questions[0][:id],
            result: true,
            user_choice: 1
          },
          {
            question_id: questions[1][:id],
            result: false,
            user_choice: 0
          }
        ]
      }
    end
  end
end
# rubocop:enable all
