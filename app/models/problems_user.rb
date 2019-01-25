# frozen_string_literal: true

class ProblemsUser < ApplicationRecord
  self.table_name = 'problems_users'

  belongs_to :problem
  belongs_to :user
  has_many :achievements, dependent: :delete_all
end
