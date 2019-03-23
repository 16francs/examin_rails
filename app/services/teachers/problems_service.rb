# frozen_string_literal: true

class Teachers::ProblemsService < ApplicationService
  def index
    keys = %i[id title content user_id updated_at]
    problems = Problem.order(updated_at: :desc).pluck(:id, :title, :content, :user_id, :updated_at)
    problems.map! { |problem| Hash[*[keys, problem].transpose.flatten] }

    problems.each do |problem|
      user = User.find_by(id: problem[:user_id]) # user_id が nil OK なため
      problem[:teacher_name] = user ? user[:name] : nil

      tag_ids = ProblemsTag.where(problem_id: problem[:id]).pluck(:tag_id)
      problem[:tags] = Tag.where(id: tag_ids).pluck(:content)

      problem[:updated_at] = default_time(problem[:updated_at])

      problem.delete(:user_id)
    end

    @response[:problems] = problems
  end

  def create(model)
    problem = model.slice(:id, :title, :content)
    problem[:created_at] = default_time(model[:created_at])
    problem[:updated_at] = default_time(model[:updated_at])

    user = User.find_by(id: model[:user_id])
    problem[:teacher_name] = user ? user[:name] : nil

    problem[:tags] = model.tags.pluck(:content)

    @response = problem
  end
end
