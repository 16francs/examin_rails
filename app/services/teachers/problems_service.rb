# frozen_string_literal: true

class Teachers::ProblemsService
  attr_reader :response

  def initialize
    @response = nil
  end

  def index
    @response = []

    keys = %i[id title content user_id updated_at]
    problems = Problem.order(updated_at: :desc).pluck(:id, :title, :content, :user_id, :updated_at)
    problems.map! { |problem| Hash[*[keys, problem].transpose.flatten] }

    problems.map! do |problem|
      user = User.find_by(id: problem[:user_id]) # user_id が nil OK なため
      problem[:teacher_name] = user ? user[:name] : nil

      tag_ids = ProblemsTag.where(problem_id: problem).pluck(:tag_id)
      problem[:tags] = Tag.where(id: tag_ids).pluck(:content)

      problem.delete(:user_id)
      problem
    end

    @response = problems
  end

  def create(problem)
    @response = {}
    @response = problem.slice(:id, :title, :content, :updated_at)

    user = User.find_by(id: problem[:user_id])
    @response[:teacher_name] = user ? user[:name] : nil

    @response[:tags] = problem.tags.pluck(:content)
  end
end
