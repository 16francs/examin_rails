# frozen_string_literal: true

class Api::Students::ProblemsController < Api::Students::BaseController
  def index
    service = Students::ProblemsService.new
    service.index
    @response = service.response
    render :index, formats: :json, handlers: :jbuilder
  end

  def show # 問題集の詳細取得(１件)
    @problem = Problem.find_by(id: params[:id])
    if @problem
      render :show, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end
end
