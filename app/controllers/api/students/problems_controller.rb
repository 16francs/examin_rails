# frozen_string_literal: true

class Api::Students::ProblemsController < Api::Students::BaseController
  def index
    service = Students::ProblemsService.new
    service.index
    @response = service.response
    render :index, formats: :json, handlers: :jbuilder
  end
end
