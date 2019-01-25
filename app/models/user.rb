# frozen_string_literal: true

class User < ApplicationRecord
  self.table_name = 'users'

  has_secure_password
end
