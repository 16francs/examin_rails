class Question < ApplicationRecord
  self.table_name = 'questions'
  self.inheritance_column = :_type_disabled
  belongs_to :problem
  has_many :answers

  validates :number,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :sentence,
            presence: true,
            length: { maximum: 200 }

  validates :type,
            presence: true,
            numericality: { only_integer: true, greater_than: 0, less_than: 10 }

  validates :correct,
            presence: true
end
