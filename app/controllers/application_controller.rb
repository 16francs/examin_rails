# frozen_string_literal: true

class ApplicationController < ActionController::API
  SECRET_KEY = Rails.application.secrets.secret_key_base

  rescue_from StandardError, with: :render_error

  private

  #  --- 認証処理 ---
  # ログインしているかの検証 <- JWT認証
  def require_login
    header = request.headers['Authorization']
    raise ApiErrors::Unauthorized unless header&.include?('Bearer ')

    # token の復号化
    token = header.split(' ').last
    @decoded = JsonWebToken.decode(token)

    # トークンの有効期限を確認
    expired_at = DateTime.parse(@decoded[:expired_at])
    raise ApiErrors::Unauthorized unless expired_at > DateTime.now

    # ログインユーザーを取得
    @current_user = User.find(@decoded[:user_id])
    raise ApiErrors::Unauthorized unless @current_user
  rescue JWT::DecodeError
    raise ApiErrors::Unauthorized
  end

  # --- エラー処理 ---
  def error_response(error)
    render json: { status: error[:status], message: error[:message] }, status: error[:status]
  end

  def render_400(error)
    error_response(error)
  end

  def render_500(error, error_instance)
    logger.error('----- status: 500 エラー内容 -----')
    logger.error(error_instance)
    logger.error('---------------------------------')
    error_response(error)
  end

  def render_error(error_instance)
    error = I18n.t("errors.#{error_instance.class}", default: :'errors.other')

    case error[:status]
    when 400 then
      render_400(error)
    when 401 then
      render_400(error)
    when 403 then
      render_400(error)
    else
      render_500(error, error_instance)
    end
  end
end
