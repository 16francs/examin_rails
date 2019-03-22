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

  def create(problem)
    @response[:problem] = problem.slice(:id, :title, :content)
    @response[:problem][:updated_at] = default_time(problem[:updated_at])

    user = User.find_by(id: problem[:user_id])
    @response[:problem][:teacher_name] = user ? user[:name] : nil

    @response[:problem][:tags] = problem.tags.pluck(:content)
  end
end
