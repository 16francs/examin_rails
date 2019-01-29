# frozen_string_literal: true

class Api::UsersController < ApplicationController
  def check_unique
    current_user = logged_in_user?

    service = UsersService.new
    service.check_unique(login_id_params, current_user)
    @response = service.response
    render :check_unique, formats: :json, handlers: :jbuilder
  end

  private

  # ログインしているかの検証 -> ログイン済みの場合，ログイン情報を返す
  def logged_in_user?
    header = request.headers['Authorization']
    return nil unless header&.include?('Bearer ')

    token = header.split(' ').last
    decoded = JsonWebToken.decode(token)

    expired_at = DateTime.parse(decoded[:expired_at])
    return nil unless expired_at > DateTime.now

    User.find(decoded[:user_id])
  rescue JWT::DecodeError
    nil
  end

  def login_id_params
    params.require(:user).permit(:login_id)
  end
end
