class Api::AuthController < ApplicationController
  def create
    if @user ||= login(params[:login_id], params[:password])
      @api_key = @user.activate
      render :create
    else
      unauthorized
    end
  end
end
