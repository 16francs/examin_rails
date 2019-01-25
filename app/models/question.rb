# frozen_string_literal: true

class Question < ApplicationRecord
  self.table_name = 'questions'

  belongs_to :problem
  has_many :achievements, dependent: :nullify
end
