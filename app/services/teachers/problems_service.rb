# frozen_string_literal: true

class Teachers::ProblemsService
  attr_reader :response

  def initialize
    @response = nil
  end

  def index
    @response = []

    keys = %i[id title content user_id created_at updated_at]
    problems = Problem.order(updated_at: :desc).pluck(:id, :title, :content, :user_id, :created_at, :updated_at)
    problems.map! { |problem| Hash[*[keys, problem].transpose.flatten] }

    problems.map! do |problem|
      user = User.find_by(id: problem[:user_id]) # user_id が nil OK なため
      problem[:teacher_name] = user ? user[:name] : nil

      problem.delete(:user_id)
      problem
    end

    @response = problems
  end
end
