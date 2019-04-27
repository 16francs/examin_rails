# frozen_string_literal: true

class Users::Contract::Update < Users::Contract::Operate
  property :id
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

  validate :login_id_unique?

  private

  def login_id_unique?
    user = User.find_by(login_id: login_id)

    errors.add(:login_id, 'not unique') if user && user[:id] != id.to_i
  end
end
