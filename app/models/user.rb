class User < ApplicationRecord
  authenticates_with_sorcery!

  self.table_name = 'users'
  has_many :api_keys, dependent: :destroy

  validates :password, length: { minimum: 6, maximum: 16 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :login_id, uniqueness: true, presence: true, length: { maximum: 16 }
  validates :name, presence: true, length: { maximum: 32 }
  validates :school, presence: true, length: { maximum: 32 }

  # ユーザーをログイン状態にする
  def activate
    # api_keyが存在するか検索
    if !api_key ||= find_api_key
      ApiKey.create(user_id: self[:id])
    else
      # ログイン中でなかった場合，ログイン中に変更する
      unless api_key[:activated]
        api_key.set_activated
        api_key.save
      end
      # 有効期限がきれていた場合，期限を延長する
      unless api_key.before_expired?
        api_key.set_expiration
        api_key.save
      end
      api_key
    end
  end

  # ユーザーをログアウト状態にする
  def inactivate
    api_key = find_api_key
    api_key[:activated] = false
    api_key.save
  end

  private

  def find_api_key
    ApiKey.find_by(user_id: self[:id])
  end
end
