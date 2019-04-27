# frozen_string_literal: true

class UsersService < ApplicationService
  def show_me(current_user)
    user = current_user.slice(:id, :login_id, :name, :school, :role)
    user[:created_at] = default_time(current_user[:created_at])
    user[:updated_at] = default_time(current_user[:updated_at])

    @response = user
  end

  def update_me(model)
    user = model.slice(:id, :login_id, :name, :school, :role)
    user[:created_at] = default_time(model[:created_at])
    user[:updated_at] = default_time(model[:updated_at])

    @response = user
  end

  def check_unique(params)
    @response[:check_unique] = User.pluck(:login_id).exclude?(params[:login_id])
    return if @response[:check_unique] || params[:id].nil?

    # ログイン済みの場合，ログインユーザーの login_id と同じなのは true を返す
    current_user = User.find(params[:id])
    raise ApiErrors::ValidationError unless current_user

    @response[:check_unique] = params[:login_id] == current_user[:login_id]
  end
end
