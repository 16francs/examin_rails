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
end
