class Api::Students::ProblemsController < Api::Students::BaseController
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

  def achievement
    @problems_user = ProblemsUser.new(problems_user_params)
    @problems_user[:problem_id] = params[:id]
    @problems_user[:user_id] = current_user[:id]
    if @problems_user.save
      render :achievement, formats: :json, handlers: :jbuilder
    else
      record_invalid(@problems_user)
    end
  end

  private

  def problems_user_params
    params.require(:problems_user).permit(achievements_attributes: %i[question_id result user_choice])
  end
end
