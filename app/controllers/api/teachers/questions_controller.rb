# frozen_string_literal: true

class Api::Teachers::QuestionsController < Api::Teachers::BaseController
  def index
    service = Teachers::QuestionsService.new
    service.index(params[:problem_id])
    @response = service.response
    render json: @response, status: :ok
  end

  def create
    options = Teachers::Questions::Operation::Create.call(
      question: question_params,
      problem_id: params[:problem_id]
    )
    service = Teachers::QuestionsService.new
    service.create(options[:model])
    @response = service.response
    render json: @response, status: :created
  end

  private

  def question_params
    params.require(:question).permit(:sentence, :correct)
  end
end
