# frozen_string_literal: true

class Api::Students::ProblemsController < Api::Students::BaseController
  def index
    service = Students::ProblemsService.new
    service.index
    @response = service.response
    render json: @response, status: :ok
  end

  def show
    service = Students::ProblemsService.new
    service.show(params)
    @response = service.response
    render json: @response, status: :ok
  end

  def achievement
    options = Students::Achievements::Operation::Create.call(
      achievements: achievements_params,
      problem_id: params[:id],
      user_id: @current_user[:id]
    )
    service = Students::ProblemsService.new
    service.achievement(options[:model])
    @response = service.response
    render json: @response, status: :created
  end

  private

  def achievements_params
    params.require(:achievements)
  end
end
