# frozen_string_literal: true

class UsersService < ApplicationService
  def show_me(current_user)
    @response = current_user.slice(:id, :login_id, :name, :school, :role, :created_at, :updated_at)
    @response[:created_at] = default_time(@response[:created_at])
    @response[:updated_at] = default_time(@response[:updated_at])
  end

  def check_unique(params)
    @response = User.pluck(:login_id).exclude?(params[:login_id])
    return if @response || params[:id].nil?

    # ログイン済みの場合，ログインユーザーの login_id と同じなのは true を返す
    current_user = User.find(params[:id])
    @response = params[:login_id] == current_user[:login_id]
  end
end
