class ApiKey < ApplicationRecord
  before_create :generate_access_token, :set_expiration, :set_activated

  self.table_name = 'api_keys'
  belongs_to :user

  EXPIRATION = DateTime.now + 2.week

  # 有効期限の確認
  def before_expired?
    self[:expires_at] > DateTime.now
  end

  # ログイン状態にする
  def set_activated
    self[:activated] = true
  end

  # 有効期限を設定
  def set_expiration
    self[:expires_at] = EXPIRATION
  end

  private

  # access_tokenの生成
  def generate_access_token
    # access_tokenがユニークな値になるまでループする
    loop do
      self[:access_token] = SecureRandom.hex
      break unless ApiKey.exists?(access_token: self[:access_token])
    end
  end
end
