# frozen_string_literal: true

class Teachers::Teachers::Contract::Create < Teachers::Teachers::Contract::Operate
  property :login_id
  property :name
  property :school
  property :password
  property :password_confirmation

  validates :login_id,
            presence: true,
            length: { in: 1..31 },
            format: { with: VALID_ENGLISH_REGEX }
  validates :name,
            presence: true,
            length: { in: 1..63 },
            format: { with: VALID_VALUE_REGEX }
  validates :school,
            presence: true,
            length: { in: 1..63 },
            format: { with: VALID_VALUE_REGEX }
  validates :password,
            presence: true,
            length: { in: 8..15 },
            format: { with: VALID_ENGLISH_REGEX }
  validates :password_confirmation,
            presence: true,
            length: { in: 8..15 },
            format: { with: VALID_ENGLISH_REGEX }

  validate :login_id_unique?
  validate :valid_password?

  private

  def login_id_unique?
    errors.add(:login_id, 'not unique') if User.pluck(:login_id).include?(login_id)
  end

  def valid_password?
    errors.add(:password, 'invalid password') unless password == password_confirmation
  end
end
