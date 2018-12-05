class Question < ApplicationRecord
  self.table_name = 'questions'
  belongs_to :problem
  has_many :achievements

  validates :sentence,
            presence: true,
            length: { maximum: 200 }

  validates :correct,
            presence: true
end
