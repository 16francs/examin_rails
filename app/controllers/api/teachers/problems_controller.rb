# frozen_string_literal: true

class Api::Teachers::ProblemsController < Api::Teachers::BaseController
  def index
    service = Teachers::ProblemsService.new
    service.index
    @response = service.response
    render json: @response, status: :ok
  end

  def create
    options = Teachers::Problems::Operation::Create.call(
      problem: problem_params,
      current_user: @current_user
    )
    service = Teachers::ProblemsService.new
    service.create(options[:model])
    @response = service.response
    render json: @response, status: :created
  end

  def download_template
    service = Teachers::ProblemsService.new
    file = service.download_template
    send_file(file[:path], type: file[:type])
  end

  def download_index
    service = Teachers::ProblemsService.new
    file = service.download_index(params[:id])
    send_data(file[:content], type: file[:type], filename: file[:name])
  end

  def download_test
    service = Teachers::ProblemsService.new
    file = service.download_test(params[:id], test_params)
    send_data(file[:content], type: file[:type], filename: file[:name])
  end

  private

  def problem_params
    params.require(:problem).permit(:title, :content, tags: [])
  end

  def test_params
    params.require(:test).permit(:count)
  end
end
