# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Teachers::Problems', type: :request do
  let!(:admin) { create(:admin) }
  let!(:problem) { create(:problem, user: admin) }
  let!(:tag) { create(:tag) }
  let!(:problems_tag) { create(:problems_tag, problem: problem, tag: tag) }
  let!(:question) { build(:question, problem: problem) }

  describe 'index action' do
    let!(:questions) { create_list(:question, 10, problem: problem) }

    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/teachers/problems/' + problem[:id].to_s + '/questions'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(admin)
        auth_params = get_auth_params(response)
        get '/api/teachers/problems/' + problem[:id].to_s + '/questions', headers: auth_params
      end

      it 'status: 200' do
        expect(response.status).to eq(200)
      end

      it 'json の検証' do
        json = JSON.parse(response.body)
        questions.map(&:reload)
        expect(json['id']).to eq(problem[:id])
        expect(json['title']).to eq(problem[:title])
        expect(json['content']).to eq(problem[:content])
        expect(json['tags']).to eq([tag[:content]])
        expect(json['teacher_name']).to eq(admin[:name])
        expect(json['count']).to eq(questions.length)
        expect(json['created_at']).to eq(default_time(problem[:created_at]))
        expect(json['updated_at']).to eq(default_time(problem[:updated_at]))
        expect(json['questions'][0]['id']).to eq(questions[0][:id])
        expect(json['questions'][0]['sentence']).to eq(questions[0][:sentence])
        expect(json['questions'][0]['correct']).to eq(questions[0][:correct])
      end
    end
  end

  describe 'create action' do
    context '未ログインの場合' do
      it 'status: 401' do
        post '/api/teachers/problems/' + problem[:id].to_s + '/questions'
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
          @size = Question.all.size
          post '/api/teachers/problems/' + problem[:id].to_s + '/questions',
               params: valid_params, headers: @auth_params
        end

        it 'status: 201' do
          expect(response.status).to eq(201)
        end

        it 'json の検証' do
          json = JSON.parse(response.body)
          question = Question.last
          expect(json['id']).to eq(question[:id])
          expect(json['problem_id']).to eq(question[:problem_id])
          expect(json['sentence']).to eq(question[:sentence])
          expect(json['correct']).to eq(question[:correct])
          expect(json['created_at']).to eq(default_time(question[:created_at]))
          expect(json['updated_at']).to eq(default_time(question[:updated_at]))
        end

        it 'size + 1' do
          expect(Question.all.size).to eq(@size + 1)
        end
      end

      context '無効なパラメータの場合' do
        it 'status: 400' do
          post '/api/teachers/problems/' + problem[:id].to_s + '/questions',
               params: sentence_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/problems/' + problem[:id].to_s + '/questions',
               params: correct_nil_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/problems/' + problem[:id].to_s + '/questions',
               params: sentence_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
          post '/api/teachers/problems/' + problem[:id].to_s + '/questions',
               params: correct_max_length_params, headers: @auth_params
          expect(response.status).to eq(400)
        end
      end
    end
  end

  describe 'create_many action' do
    before do
      file_type = 'application/vnd.ms-excel'
      file_path = File.open(Rails.root.join('lib/test', 'new_questions.xlsx'))
      @file = Rack::Test::UploadedFile.new(file_path, file_type)
      other_file_path = File.open(Rails.root.join('lib/test', 'questions.xlsx'))
      @other_file = Rack::Test::UploadedFile.new(other_file_path, file_type)
    end

    context '未ログインの場合' do
      it 'status: 401' do
        post '/api/teachers/problems/' + problem[:id].to_s + '/questions/upload'
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
          @size = Question.all.size
          post '/api/teachers/problems/' + problem[:id].to_s + '/questions/upload',
               headers: @auth_params, params: valid_upload_params
        end

        it 'status: 201' do
          expect(response.status).to eq(201)
        end

        it 'json の検証' do
          json = JSON.parse(response.body)
          question = Question.last
          expect(json['questions'][0]['id']).to eq(question[:id])
          expect(json['questions'][0]['sentence']).to eq(question[:sentence])
          expect(json['questions'][0]['sentence']).to eq(question[:sentence])
          expect(json['questions'][0]['correct']).to eq(question[:correct])
          expect(json['questions'][0]['created_at']).to eq(default_time(question[:created_at]))
          expect(json['questions'][0]['updated_at']).to eq(default_time(question[:updated_at]))
        end

        it 'size + 1' do
          expect(Question.all.size).to eq(@size + 1)
        end
      end

      context '無効なパラメータの場合' do
        it 'status: 400' do
          post '/api/teachers/problems/' + problem[:id].to_s + '/questions/upload',
               headers: @auth_params, params: invalid_upload_params
          expect(response.status).to eq(400)
        end
      end
    end

    def valid_upload_params
      {
        file: @file
      }
    end

    def invalid_upload_params
      {
        file: @other_file
      }
    end
  end

  def valid_params
    {
      question: {
        sentence: question[:sentence],
        correct: question[:correct]
      }
    }
  end

  def sentence_nil_params
    {
      question: {
        sentence: nil,
        correct: question[:correct]
      }
    }
  end

  def correct_nil_params
    {
      question: {
        sentence: nil,
        correct: question[:correct]
      }
    }
  end

  def sentence_max_length_params
    {
      question: {
        sentence: 'a' * 64,
        correct: question[:correct]
      }
    }
  end

  def correct_max_length_params
    {
      question: {
        sentence: question[:sentence],
        correct: 'a' * 64
      }
    }
  end
end
# rubocop:enable all
