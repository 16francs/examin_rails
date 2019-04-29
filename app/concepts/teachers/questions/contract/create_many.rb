# frozen_string_literal: true

class Teachers::Questions::Contract::CreateMany < Teachers::Questions::Contract::Operate
  property :sentence
  property :correct

  validates :sentence,
            presence: true,
            length: { in: 1..63 }
  validates :correct,
            presence: true,
            length: { in: 1..63 }
end
