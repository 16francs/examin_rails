class Api::Teachers::BaseController < ApplicationController
  before_action :require_login
  before_action :log_in_teacher?

  private

  # 講師であるかの確認
  def log_in_teacher?
    user = current_user
    unauthorized if user[:role] != 1 && user[:role] != 2 && user[:role] != 3
  end

  # ログイン中の講師情報と一致するか確認
  def correct_teacher?(user)
    user == current_user
  end

  # 管理者であるかの確認
  def admin_teacher
    forbidden unless current_user[:role] == 2 || current_user[:role] == 3
  end
end
