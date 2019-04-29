# frozen_string_literal: true

class Teachers::Students::Contract::Create < Teachers::Students::Contract::Operate
  property :login_id
  property :name
  property :school

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
    errors.add(:login_id, 'not unique') if User.pluck(:login_id).include?(login_id)
  end
end
