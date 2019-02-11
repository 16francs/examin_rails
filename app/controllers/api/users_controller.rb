# frozen_string_literal: true

class Api::UsersController < ApplicationController
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
