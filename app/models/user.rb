# frozen_string_literal: true

class User < ApplicationRecord
  self.table_name = 'users'

  has_many :problems, dependent: :nullify
  has_many :problems_users, dependent: :delete_all

  has_secure_password
end
