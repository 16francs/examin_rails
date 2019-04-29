# frozen_string_literal: true

class Teachers::QuestionsService < ApplicationService
  def index(problem_id)
    keys = %i[id sentence correct]
    questions = Question.where(problem_id: problem_id).pluck(:id, :sentence, :correct)
    questions.map! { |question| Hash[*[keys, question].transpose.flatten] }

    @response[:questions] = questions
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
