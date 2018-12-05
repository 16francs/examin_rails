class ProblemsUser < ApplicationRecord
  self.table_name = 'problems_users'
  belongs_to :user
  belongs_to :problem
  has_many :achievements, dependent: :delete_all
end
