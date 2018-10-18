class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  private

  # 未ログインの場合の処理
  def unauthorized
    render json: { status: :error, message: :unauthorized }, status: :unauthorized
  end

  # モデルのバリデーションエラー時の処理
  def record_invalid(model)
    render json: { status: :error, message: :record_invalid, data: model.errors },
           status: :unprocessable_entity
  end

  # ログインしているかの検証
  def require_login
    access_token = request.headers['access-token']
    api_key = ApiKey.find_by(access_token: access_token)
    unauthorized if !api_key || !api_key.before_expired? || !api_key[:activated] || User.find(api_key[:user_id]).nil?
  end
end
