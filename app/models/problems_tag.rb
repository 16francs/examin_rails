# frozen_string_literal: true

class ProblemsTag < ApplicationRecord
  self.table_name = 'problems_tags'

  belongs_to :problem
  belongs_to :tag
end
