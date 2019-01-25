# frozen_string_literal: true

class ApplicationController < ActionController::API
  SECRET_KEY = Rails.application.secrets.secret_key_base

  rescue_from StandardError, with: :internal_server_error

  private

  # ログインしているかの検証 <- JWT認証
  def require_login
    header ||= request.headers['Authorization']
    unauthorized unless header

    # token の復号化
    token = header.split(' ').last
    @decoded = JsonWebToken.decode(token)

    # トークンの有効期限を確認
    unauthorized unless @decoded[:expired_at] < DateTime.now

    # ログインユーザーを取得
    @current_user = User.find(@decoded[:user_id])
    unauthorized unless @current_user
  end

  # --- エラー処理 ---
  def bad_request
    render json: { status: 400, description: '' }, status: :bad_request
  end

  def unauthorized
    render json: { status: 401, description: '' }, status: :unauthorized
  end

  def forbidden
    render json: { status: 403, desription: '' }, status: :forbidden
  end

  def not_found
    render json: { status: 404, description: '' }, status: :not_found
  end

  def record_invalid(model)
    logger.error('----- status: 422 エラー内容 -----')
    logger.error(model.errors.messages)
    logger.error('---------------------------------')
    render json: { status: 422, description: '' }, status: :unprocessable_entity
  end

  def internal_server_error(error)
    logger.error('----- status: 500 エラー内容 -----')
    logger.error(error)
    logger.error('---------------------------------')
    render json: { status: 500, description: '' }, status: :internal_server_error
  end
end
