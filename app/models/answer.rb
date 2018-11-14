class Answer < ApplicationRecord
  self.table_name = 'answers'
  belongs_to :question

  validates :choice,
            presence: true,
            length: { maximum: 200 }
end
