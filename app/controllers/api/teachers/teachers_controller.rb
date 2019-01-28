# frozen_string_literal: true

class Api::Teachers::TeachersController < Api::Teachers::BaseController
  def create
    render json: {}, status: :ok
  end

  private

  def teacher_params
    params.require(:teacher).permit(:login_id, :name, :school, :password, :password_confirmation)
  end
end
