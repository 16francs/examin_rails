# frozen_string_literal: true

class Teachers::QuestionsService < ApplicationService
  def index(problem_id)
    # 問題集を取得
    problem = Problem.find(problem_id)
    @response = problem.slice(:id, :title, :content)
    @response[:created_at] = default_time(problem[:created_at])
    @response[:updated_at] = default_time(problem[:updated_at])
    @response[:tags] = problem.tags.pluck(:content)

    user = User.find_by(id: problem[:user_id])
    @response[:teacher_name] = user ? user[:name] : nil

    # 問題一覧を取得
    keys = %i[id sentence correct]
    questions = Question.where(problem_id: problem_id).pluck(:id, :sentence, :correct)
    questions.map! { |question| Hash[*[keys, question].transpose.flatten] }
    @response[:questions] = questions

    # 問題数を取得
    @response[:count] = questions.length
  end

  def create(model)
    question = model.slice(:id, :problem_id, :sentence, :correct)
    question[:created_at] = default_time(model[:created_at])
    question[:updated_at] = default_time(model[:updated_at])

    @response = question
  end

  def create_many(models)
    models.map! do |model|
      question = model.slice(:id, :sentence, :correct)
      question[:created_at] = default_time(model[:created_at])
      question[:updated_at] = default_time(model[:updated_at])

      question
    end

    @response[:questions] = models
  end
end
