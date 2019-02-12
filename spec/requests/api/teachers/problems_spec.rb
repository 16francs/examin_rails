# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe 'Api::Teachers::Problems', type: :request do
  let!(:admin) { create(:admin) }
  let!(:problem) { build(:problem) }
  let!(:tag) { build(:tag) }

  describe 'index action' do
    let!(:problems) { create_list(:problem, 10, user: admin) }

    context '未ログインの場合' do
      it 'status: 401' do
        get '/api/teachers/problems'
        expect(response.status).to eq(401)
      end
    end

    context 'ログイン済みの場合' do
      before do
        login(admin)
        auth_params = get_auth_params(response)
        get '/api/teachers/problems', headers: auth_params
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

  describe 'create action' do
    context '未ログインの場合' do
      it 'status: 401' do
        post '/api/teachers/problems'
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
          @problem_size = Problem.all.size
          @problems_tag_size = ProblemsTag.all.size
          @tag_size = Tag.all.size
          post '/api/teachers/problems', params: valid_params, headers: @auth_params
        end

        it 'status: 200' do
          expect(response.status).to eq(200)
        end

        it 'size: +1' do
          expect(Problem.all.size).to eq(@problem_size + 1)
          expect(ProblemsTag.all.size).to eq(@problems_tag_size + 1)
          expect(Tag.all.size).to eq(@tag_size + 1)
        end
      end

      context '無効なパラメータの場合' do
        it 'status: 422' do
          post '/api/teachers/problems',
               params: title_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/problems',
               params: content_nil_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/problems',
               params: title_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/problems',
               params: content_max_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/problems',
               params: title_format_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/problems',
               params: tag_length_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/problems',
               params: tags_size_params, headers: @auth_params
          expect(response.status).to eq(422)
          post '/api/teachers/problems',
               params: unique_tags_params, headers: @auth_params
          expect(response.status).to eq(422)
        end
      end
    end
  end

  def valid_params
    {
      problem: {
        title: problem[:title],
        content: problem[:content],
        tags: [tag[:content]]
      }
    }
  end

  def title_nil_params
    {
      problem: {
        title: nil,
        content: problem[:content],
        tags: [tag[:content]]
      }
    }
  end

  def content_nil_params
    {
      problem: {
        title: problem[:title],
        content: nil,
        tags: [tag[:content]]
      }
    }
  end

  def title_max_length_params
    {
      problem: {
        title: 'a' * 32,
        content: problem[:content],
        tags: [tag[:content]]
      }
    }
  end

  def content_max_length_params
    {
      problem: {
        title: problem[:title],
        content: 'a' * 64,
        tags: [tag[:content]]
      }
    }
  end

  def title_format_params
    {
      problem: {
        title: '!#$-%&@*/',
        content: problem[:content],
        tags: [tag[:content]]
      }
    }
  end

  def tag_length_params
    {
      problem: {
        title: '!#$-%&@*/',
        content: problem[:content],
        tags: ['a' * 16]
      }
    }
  end

  def tags_size_params
    {
      problem: {
        title: '!#$-%&@*/',
        content: problem[:content],
        tags: %w[a b c d e]
      }
    }
  end

  def unique_tags_params
    {
      problem: {
        title: '!#$-%&@*/',
        content: problem[:content],
        tags: [tag[:content], tag[:content]]
      }
    }
  end
end
# rubocop:enable all
