class Api::Teachers::ProblemsUsersController < Api::Teachers::BaseController
  def index
    @problems_users = ProblemsUser.all
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @problems_user = ProblemsUser.find_by(params[:id])
    if @problems_user
      render :show, formats: :json, handlers: :jbuilder
    else
      not_found
    end
  end
end
