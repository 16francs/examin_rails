# frozen_string_literal: true

class Teachers::Questions::Contract::Create < Teachers::Questions::Contract::Operate
  property :problem_id
  property :sentence
  property :correct

  validates :sentence,
            presence: true,
            length: { in: 1..63 }
  validates :correct,
            presence: true,
            length: { in: 1..63 }

  validate :problem_presence?

  private

  def problem_presence?
    errors.add(:problem_id, 'problem is not presence') unless Problem.pluck(:id).include?(problem_id.to_i)
  end
end
