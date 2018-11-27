class Api::AuthController < ApplicationController
  before_action :require_login, only: %i[show update destroy]

  def show
    @user = current_user
    @api_key = current_user.api_key
    render :show, formats: :json, handler: :jbuilder
  end

  def create
    if @user ||= login(params[:login_id], params[:password])
      @api_key = @user.activate
      render :create, formats: :json, handler: :jbuilder
    else
      unauthorized
    end
  end

  def update
    if current_user.update(user_params)
      render json: { status: :success }, status: :ok
    else
      record_invalid(current_user)
    end
  end

  def destroy
    user = current_user
    user.inactivate
    render json: { status: :success }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:login_id, :password, :password_confirmation, :name, :school)
  end
end
