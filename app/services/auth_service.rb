# frozen_string_literal: true

class AuthService < ApplicationService
  def index(token, decoded, current_user)
    @response[:token] = token
    @response[:expired_at] = default_time(DateTime.parse(decoded[:expired_at]))
    @response[:user] = { id: current_user[:id], role: current_user[:role] }
  end

  def create(user)
    expired_at = DateTime.now + 2.week
    @response[:token] = JsonWebToken.encode(user_id: user[:id], expired_at: expired_at)
    @response[:expired_at] = default_time(expired_at)
    @response[:user] = { id: user[:id], role: user[:role] }
  end
end
