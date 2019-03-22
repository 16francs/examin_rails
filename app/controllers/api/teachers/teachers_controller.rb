# frozen_string_literal: true

class Api::Teachers::TeachersController < Api::Teachers::BaseController
  def index
    service = Teachers::TeachersService.new
    service.index
    @response = service.response
    render json: @response, status: :ok
  end

  def create
    options = Teachers::Teachers::Operation::Create.call(
      teacher: teacher_params
    )
    service = Teachers::TeachersService.new
    service.create(options[:model])
    @response = service.response
    render json: @response, status: :created
  end

  private

  def teacher_params
    params.require(:teacher).permit(:login_id, :name, :school, :password, :password_confirmation)
  end
end
