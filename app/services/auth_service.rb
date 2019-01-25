# frozen_string_literal: true

class AuthService
  attr_reader :response

  def initialize
    @response = nil
  end

  def index(token, decoded, current_user)
    @response = {}

    @response[:token] = token
    @response[:expired_at] = decoded[:expired_at]
    @response[:user] = { id: current_user[:id], role: current_user[:role] }
  end

  def create(user)
    @response = {}

    expired_at = DateTime.now + 2.week
    @response[:token] = JsonWebToken.encode(user_id: user[:id], expired_at: expired_at)
    @response[:expired_at] = expired_at
    @response[:user] = { id: user[:id], role: user[:role] }
  end
end
