# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base

  # トークンの生成
  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY)
  end

  # トークンの復号化
  def self.decode(token)
    JWT.decode(token, SECRET_KEY)[0]
  end
end
