# frozen_string_literal: true

class UsersService
  attr_reader :response

  def initialize
    @response = nil
  end

  def check_unique(params, current_user)
    @response = User.pluck(:login_id).exclude?(params[:login_id])
    # ログイン済みの場合，ログインユーザーの login_id と同じなのは true を返す
    @response = params[:login_id] == current_user[:login_id] if !@response && current_user
  end
end
