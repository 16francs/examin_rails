# frozen_string_literal: true

class UsersService
  attr_reader :response

  def initialize
    @response = nil
  end

  def check_unique(params)
    @response = User.pluck(:login_id).exclude?(params[:login_id])

    # ログイン済みの場合，ログインユーザーの login_id と同じなのは true を返す
    if !@response && params[:id]
      current_user = User.find(params[:id])
      @response = params[:login_id] == current_user[:login_id]
    end
  end
end
