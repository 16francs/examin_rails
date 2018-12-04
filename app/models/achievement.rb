class Achievement < ApplicationRecord
  self.table_name = 'achievements'
  belongs_to :problems_user
  belongs_to :question

  validates :result,
            presence: true,
            inclusion: { in: [true, false] }

  validates :user_choice,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: -1,
              less_than_or_equal_to: 10
            }

  validates :answer_time,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
end
