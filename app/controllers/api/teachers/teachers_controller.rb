# frozen_string_literal: true

class Api::Teachers::TeachersController < Api::Teachers::BaseController
  def index
    service = Teachers::TeachersService.new
    service.index
    @response = service.response
    render :index, formats: :json, handlers: :jbuilder
  end

  def create
    Teachers::Teachers::Operation::Create.call(
      teacher: teacher_params
    )
    render json: {}, status: :ok
  end

  private

  def teacher_params
    params.require(:teacher).permit(:login_id, :name, :school, :password, :password_confirmation)
  end
end
