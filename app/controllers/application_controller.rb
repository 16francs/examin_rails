class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  private

  # アクセスが禁止場所へのリクエスト時の処理
  def forbidden
    render json: { status: :error, message: :forbidden }, status: :forbidden
  end

  def not_found
    render json: { status: :error, message: :not_found }, status: :not_found
  end

  # モデルのバリデーションエラー時の処理
  def record_invalid(model)
    render json: { status: :error, message: :record_invalid, data: model.errors }, status: :unprocessable_entity
  end

  # 未ログインの場合の処理
  def unauthorized
    render json: { status: :error, message: :unauthorized }, status: :unauthorized
  end

  # ログインしているかの検証
  def require_login
    access_token = request.headers['access-token']
    api_key = ApiKey.find_by(access_token: access_token)
    unauthorized if !api_key || !api_key.before_expired? || !api_key[:activated] || User.find(api_key[:user_id]).nil?
  end

  # ログイン中の user 情報を返す
  def current_user
    api_key = ApiKey.find_by(access_token: request.headers['access-token'])
    User.find(api_key[:user_id]) if api_key # gem と競合するため，api_keyが存在する場合のみ値を返す
  end
end
