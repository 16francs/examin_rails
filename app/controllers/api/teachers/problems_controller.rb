class Api::Teachers::ProblemsController < Api::Teachers::BaseController
  def index
    @problems = Problem.all
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @problem = Problem.find_by(id: params[:id])
    if @problem
      render :show, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end
end
