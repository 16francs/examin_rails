# frozen_string_literal: true

class Students::Achievements::Contract::Create < Students::Achievements::Contract::Operate
  property :question_id
  property :result
  property :user_choice

  validates :question_id,
            presence: true
  validates :user_choice,
            numericality: { only_integer: true }

  private

  def question_presence?
    errors.add(:base, 'question is not presence') unless Question.pluck(:id).include?(:id)
  end
end
