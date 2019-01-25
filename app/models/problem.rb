# frozen_string_literal: true

class Problem < ApplicationRecord
  self.table_name = 'problems'

  belongs_to :user, optional: true
  has_many :problems_users, dependent: :delete_all
  has_many :users, through: :problems_users
  has_many :questions, dependent: :delete_all
end
