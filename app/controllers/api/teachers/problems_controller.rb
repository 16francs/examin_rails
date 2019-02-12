# frozen_string_literal: true

class Api::Teachers::ProblemsController < Api::Teachers::BaseController
  def index
    service = Teachers::ProblemsService.new
    service.index
    @response = service.response
    render :index, formats: :json, handlers: :jbuilder
  end

  def create
    options = Teachers::Problems::Operation::Create.call(
      problem: problem_params,
      current_user: @current_user
    )
    service = Teachers::ProblemsService.new
    service.create(options[:model])
    @response = service.response
    render :create, formats: :json, handlers: :jbuilder
  end

  private

  def problem_params
    params.require(:problem).permit(:title, :content, tags: [])
  end
end
