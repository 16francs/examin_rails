class Achievement < ApplicationRecord
  self.table_name = 'achievements'
  belongs_to :problems_user
  belongs_to :question
end
