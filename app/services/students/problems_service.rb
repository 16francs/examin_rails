# frozen_string_literal: true

class Students::ProblemsService < ApplicationService
  def index
    keys = %i[id title content user_id created_at updated_at]
    problems = Problem.pluck(:id, :title, :content, :user_id, :created_at, :updated_at)
    problems.map! { |problem| Hash[*[keys, problem].transpose.flatten] }

    problems.each do |problem|
      user = User.find_by(id: problem[:user_id]) # user_id が nil OK なため
      problem[:teacher_name] = user ? user[:name] : nil

      problem[:created_at] = default_time(problem[:created_at])
      problem[:updated_at] = default_time(problem[:updated_at])

      problem.delete(:user_id)
    end

    @response[:problems] = problems
  end

  def show(params)
    problem = Problem.find_by(id: params[:id])
    raise ApiErrors::BadRequest unless problem

    keys = %i[id sentence correct]
    questions = problem.questions.pluck(:id, :sentence, :correct)
    questions.map! { |question| Hash[*[keys, question].transpose.flatten] }

    @response[:problem] = problem.slice(:id, :title, :user_id, :created_at, :updated_at)
    @response[:questions] = questions
  end

  def achievement(model)
    problems_user = model.slice(:id, :problem_id, :user_id, :created_at, :updated_at)

    keys = %i[id question_id result user_choice]
    achievements = model[:achievements].map { |achievement| achievement[keys] }
    achievements.map! { |achievement| Hash[*[keys, achievement].transpose.flatten] }

    @response[:problems_user] = problems_user
    @response[:problems_user][:achievements] = achievements
  end
end
