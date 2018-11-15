class Api::Students::BaseController < ApplicationController
  before_action :require_login
  before_action :log_in_student?

  private

  # 生徒であるかの確認
  def log_in_student?
    user = current_user
    unauthorized if user[:role] != 0
  end

  # ログイン中の生徒情報と一致するか確認
  def correct_student?(user)
    user == current_user
  end
end
