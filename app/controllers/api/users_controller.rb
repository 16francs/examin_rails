# frozen_string_literal: true

class Api::UsersController < ApplicationController
  before_action :require_login, only: :show_me

  def show_me
    service = UsersService.new
    service.show_me(@current_user)
    @response = service.response
    render json: @response, status: :ok
  end

  def update_me
    options = Users::Operation::Update.call(
      id: @current_user[:id],
      user: user_params
    )
    service = UsersService.new
    service.update_me(options[:model])
    @response = service.response
    render json: @response, status: :ok
  end

  def check_unique
    service = UsersService.new
    service.check_unique(login_id_params)
    @response = service.response
    render json: @response, status: :ok
  end

  private

  def login_id_params
    params.require(:user).permit(:id, :login_id)
  end

  def user_params
    params.require(:user).permit(:login_id, :name, :school)
  end
end
