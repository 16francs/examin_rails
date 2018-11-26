class Api::Students::ProblemsUsersController < Api::Students::BaseController
  before_action :correct_student, only: %i[show]

  def index
    @problems_users = ProblemsUser.where(user_id: current_user)
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @problems_user = ProblemsUser.find_by(params[:id])
    render :show, formats: :json, handlers: :jbuilder
  end

  private

  def correct_student
    problems_user = ProblemsUser.find_by(params[:id])
    forbidden unless correct_student?(problems_user.user)
  end
end
