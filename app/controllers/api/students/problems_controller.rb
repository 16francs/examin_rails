# frozen_string_literal: true

class Api::Students::ProblemsController < Api::Students::BaseController
  def index
    service = Students::ProblemsService.new
    service.index
    @response = service.response
    render :index, formats: :json, handlers: :jbuilder
  end

  def show
    @problem = Problem.find_by(id: params[:id])
    raise ApiErrors::BadRequest unless @problem

    render :show, formats: :json, handlers: :jbuilder
  end

  def achievement
    @problems_user = ProblemsUser.new(problem_id: params[:id], user_id: @current_user[:id])
    new_achievements(@problems_user)
    if @problems_user.save
      render :achievement, formats: :json, handlers: :jbuilder
    else
      record_invalid(@problems_user)
    end
  end

  private

  def new_achievements(problems_user)
    request = params[:achievements]
    request.each do |achievement_params|
      problems_user.achievements.build(question_id: achievement_params[:question_id],
                                       result: achievement_params[:result],
                                       user_choice: achievement_params[:user_choice],
                                       # answer_time: achievement_params[:answer_time]
                                       answer_time: 0)
    end
  end
end
