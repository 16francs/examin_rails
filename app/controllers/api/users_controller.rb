# frozen_string_literal: true

class Api::UsersController < ApplicationController
  before_action :require_login, only: :show_me

  def show_me
    service = UsersService.new
    service.show_me(@current_user)
    @response = service.response
    render :show_me, formats: :json, handlers: :jbuilder
  end

  def check_unique
    service = UsersService.new
    service.check_unique(login_id_params)
    @response = service.response
    render :check_unique, formats: :json, handlers: :jbuilder
  end

  private

  def login_id_params
    params.require(:user).permit(:id, :login_id)
  end
end
