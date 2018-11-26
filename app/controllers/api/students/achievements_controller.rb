class Api::Students::AchievementsController < Api::Students::BaseController
  before_action :correct_student, only: %i[show]

  def index
    @problems_users = ProblemsUser.where(user_id: current_user)
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @problems_user = ProblemsUser.find_by(params[:id])
    render :show, formats: :json, handlers: :jbuilder
  end

  def create
    @problems_user = ProblemsUser.new(problems_user_params)
    @problems_user[:problem_id] = params[:problem_id]
    @problems_user[:user_id] = current_user[:id]
    if @problems_user.save
      render :create, formats: :json, handlers: :jbuilder
    else
      record_invalid(@problems_user)
    end
  end

  private

  def correct_student
    problems_user = ProblemsUser.find_by(params[:id])
    forbidden unless correct_student?(problems_user.user)
  end

  def problems_user_params
    params.require(:problems_user).permit(achievements_attributes: %i[question_id result user_choice])
  end
end
