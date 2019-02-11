# frozen_string_literal: true

class Tag < ApplicationRecord
  self.table_name = 'tags'

  has_many :problems_tags
  has_many :problems, through: :problems_tags
end
