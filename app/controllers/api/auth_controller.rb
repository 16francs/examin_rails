# frozen_string_literal: true

class Api::AuthController < ApplicationController
  before_action :require_login, only: :index

  def index
    token = request.headers['Authorization'].split(' ').last

    service = AuthService.new
    service.index(token, @decoded, @current_user)
    @response = service.response
    render json: @response, status: :ok
  end

  def create
    @user = User.find_by(login_id: params[:login_id])
    raise ApiErrors::Unauthorized unless @user&.authenticate(params[:password])

    service = AuthService.new
    service.create(@user)
    @response = service.response
    render json: @response, status: :ok
  end
end
