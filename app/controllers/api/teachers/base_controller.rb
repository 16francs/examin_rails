class Api::Teachers::BaseController < ApplicationController
  before_action :require_login

  private

  # ログインしているかの検証
  def require_login
    access_token = request.headers['access-token']
    api_key = ApiKey.find_by(access_token: access_token)
    unauthorized if !api_key || !api_key.before_expired? || !api_key[:activated] || User.find(api_key[:user_id]).nil?
  end
end
