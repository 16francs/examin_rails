class Api::Teachers::QuestionsController < Api::Teachers::BaseController
  def index
    @questions = Question.where(problem_id: params[:problem_id])
    render :index, formats: :json, handlers: :jbuilder
  end
end
