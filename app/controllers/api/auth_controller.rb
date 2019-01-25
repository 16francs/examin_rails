# frozen_string_literal: true

class Api::AuthController < ApplicationController
  def create
    @user = User.find_by(login_id: params[:login_id])
    if @user&.authenticate(params[:password])
      service = AuthService.new
      service.create(@user)
      @response = service.response
      render :create, formats: :json, handlers: :jbuilder
    else
      unauthorized
    end
  end
end
