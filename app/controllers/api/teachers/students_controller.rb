# frozen_string_literal: true

class Api::Teachers::StudentsController < Api::Teachers::BaseController
  def index
    service = Teachers::StudentsService.new
    service.index
    @response = service.response
    render json: @response, status: :ok
  end

  def create
    options = Teachers::Students::Operation::Create.call(
      student: student_params
    )
    service = Teachers::StudentsService.new
    service.create(options[:model])
    @response = service.response
    render json: @response, status: :created
  end

  private

  def student_params
    params.require(:student).permit(:login_id, :name, :school)
  end
end
