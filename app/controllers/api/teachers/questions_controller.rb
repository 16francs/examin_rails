class Api::Teachers::QuestionsController < Api::Teachers::BaseController
  def index
    @questions = Question.where(problem_id: params[:problem_id])
    if @questions.length.positive?
      render :index, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end
end
