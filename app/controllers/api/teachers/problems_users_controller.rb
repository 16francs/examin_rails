class Api::Teachers::ProblemsUsersController < Api::Teachers::BaseController
  def index
    @problems_users = ProblemsUser.all
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @problems_user = ProblemsUser.find_by(params[:id])
    render :show, formats: :json, handlers: :jbuilder
  end
end
