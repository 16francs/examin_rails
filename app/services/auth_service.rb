# frozen_string_literal: true

class AuthService
  attr_reader :response

  def initialize
    @response = nil
end

  def create(user)
    @response = {}

    expired_at = DateTime.now + 2.week
    @response[:token] = JsonWebToken.encode(user_id: user[:id], expired_at: expired_at)
    @response[:expired_at] = expired_at
    @response[:user] = { id: user[:id], role: user[:role] }
  end
end
