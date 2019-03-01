# frozen_string_literal: true

class Api::Teachers::QuestionsController < Api::Teachers::BaseController
  def index
    service = Teachers::QuestionsService.new
    service.index(params[:problem_id])
    @response = service.response
    render :index, formats: :json, handlers: :jbuilder
  end
end
