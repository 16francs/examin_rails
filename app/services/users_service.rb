# frozen_string_literal: true

class UsersService
  attr_reader :response

  def initialize
    @response = nil
  end

  def show_me(current_user)
    @response = current_user
  end

  def check_unique(params)
    @response = User.pluck(:login_id).exclude?(params[:login_id])
    return if @response || params[:id].nil?

    # ログイン済みの場合，ログインユーザーの login_id と同じなのは true を返す
    current_user = User.find(params[:id])
    @response = params[:login_id] == current_user[:login_id]
  end
end
