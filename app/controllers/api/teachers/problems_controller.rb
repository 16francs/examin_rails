# frozen_string_literal: true

class Api::Teachers::ProblemsController < Api::Teachers::BaseController
  def index
    service = Teachers::ProblemsService.new
    service.index
    @response = service.response
    render :index, formats: :json, handlers: :jbuilder
  end
end
