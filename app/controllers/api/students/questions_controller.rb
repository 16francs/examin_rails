class Api::Students::QuestionsController < Api::Students::BaseController
  def index
    @questions = Question.where(problem_id: params[:problem_id])
    render :index, formats: :json, handlers: :jbuilder
  end

  def random
    if question_ids ||= random_question_ids
      @questions = Question.where(id: question_ids)
      render :random, formats: :json, handlers: :jbuilder
    else
      render json: { status: :error, message: 'not found count param' }, status: :unprocessable_entity
    end
  end

  private

  def random_question_ids
    Question.where(problem_id: params[:problem_id]).pluck(:id).sample(params[:count].to_i) if params[:count]
  end
end
