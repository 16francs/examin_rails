class Api::AuthController < ApplicationController
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
    api_key = ApiKey.find_by(access_token: access_token)
    if api_key
      user = User.find(api_key[:user_id])
      user.inactivate
      render json: { status: :success }
    else
      render json: { status: :error }, status: :not_found
    end
  end
end
