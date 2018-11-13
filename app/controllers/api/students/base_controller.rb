class Api::Students::BaseController < ApplicationController
  before_action :require_login
  before_action :log_in_student?

  private

  # 生徒であるかの確認
  def log_in_student?
    access_token = request.headers['access-token']
    api_key = ApiKey.find_by(access_token: access_token)
    user = User.find(api_key[:user_id])
    if user.nil?
      unauthorized
    elsif user[:role] != 1 && user[:role] != 0
      unauthorized
    end
  end

  # ログイン中の生徒情報と一致するか確認
  def correct_student?(user)
    user == current_user
  end
end
