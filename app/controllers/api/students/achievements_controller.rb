class Api::Students::AchievementsController < Api::Students::BaseController
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

  def problems_user_params
    params.require(:problems_user).permit(achievements_attributes: %i[question_id result user_choice])
  end
end
