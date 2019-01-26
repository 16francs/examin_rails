# frozen_string_literal: true

class ApplicationController < ActionController::API
  SECRET_KEY = Rails.application.secrets.secret_key_base

  rescue_from StandardError, with: :internal_server_error

  private

  # ログインしているかの検証 <- JWT認証
  def require_login
    header = request.headers['Authorization']
    return unauthorized unless header&.include?('Bearer ')

    # token の復号化
    token = header.split(' ').last
    @decoded = JsonWebToken.decode(token)

    # トークンの有効期限を確認
    expired_at = DateTime.parse(@decoded[:expired_at])
    return unauthorized unless expired_at > DateTime.now

    # ログインユーザーを取得
    @current_user = User.find(@decoded[:user_id])
    unauthorized unless @current_user
  rescue JWT::DecodeError
    unauthorized
  end

  # --- エラー処理 ---
  def error_response(status)
    err = I18n.t("errors.#{status}", default: :'errors.other')
    render json: { status: err[:status], desciption: err[:description] }, status: err[:status]
  end

  def bad_request
    error_response('BadRequest')
  end

  def unauthorized
    error_response('Unauthorized')
  end

  def forbidden
    error_response('Forbidden')
  end

  def not_found
    error_response('NotFound')
  end

  def internal_server_error(error)
    logger.error('----- status: 500 エラー内容 -----')
    logger.error(error)
    logger.error('---------------------------------')
    error_response('InternalServerError')
  end
end
