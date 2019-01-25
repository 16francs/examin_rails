# frozen_string_literal: true

class Api::AuthController < ApplicationController
  before_action :require_login, only: :index

  def index
    token = request.headers['Authorization'].split(' ').last

    service = AuthService.new
    service.index(token, @decoded, @current_user)
    @response = service.response
    render :index, formats: :json, handlers: :jbuilder
  end

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
