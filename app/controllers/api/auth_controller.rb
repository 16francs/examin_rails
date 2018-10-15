class Api::AuthController < ApplicationController
  def create
    if @user ||= login(params[:login_id], params[:password])
      @api_key = @user.activate
      render :create, formats: :json, handler: :jbuilder
    else
      unauthorized
    end
  end
end
