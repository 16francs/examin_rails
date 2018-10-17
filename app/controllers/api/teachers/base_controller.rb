class Api::Teachers::BaseController < ApplicationController
  before_action :require_login
  before_action :log_in_teacher?

  private

  # 講師であるかの確認
  def log_in_teacher?
    access_token = request.headers['access-token']
    api_key = ApiKey.find_by(access_token: access_token)
    user = User.find(api_key[:user_id])
    if user.nil?
      unauthorized
    elsif user[:role] != 1 && user[:role] != 2 && user[:role] != 3
      unauthorized
    end
  end
end
