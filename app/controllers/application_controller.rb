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
end
