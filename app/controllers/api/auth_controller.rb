class Api::AuthController < ApplicationController
  before_action :require_login, only: %i[show destroy]

  def show
    access_token = request.headers['access-token']
    if @api_key ||= ApiKey.find_by(access_token: access_token)
      @user = User.find(@api_key[:user_id])
      render :show, formats: :json, handler: :jbuilder
    else
      render json: { status: :error }, status: :not_found
    end
  end

  def create
    if @user ||= login(params[:login_id], params[:password])
      @api_key = @user.activate
      render :create, formats: :json, handler: :jbuilder
    else
      unauthorized
    end
  end

  def destroy
    access_token = request.headers['access-token']
    if api_key ||= ApiKey.find_by(access_token: access_token)
      user = User.find(api_key[:user_id])
      user.inactivate
      render json: { status: :success }
    else
      render json: { status: :error }, status: :not_found
    end
  end
end
