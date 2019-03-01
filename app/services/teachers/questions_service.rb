# frozen_string_literal: true

class Teachers::QuestionsService
  attr_reader :response

  def initialize
    @response = nil
  end

  def index(problem_id)
    keys = %i[id sentence correct]
    questions = Question.where(problem_id: problem_id).pluck(:id, :sentence, :correct)
    questions.map! { |question| Hash[*[keys, question].transpose.flatten] }

    @response = questions
  end
end
