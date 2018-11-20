class Problem < ApplicationRecord
  self.table_name = 'problems'
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :answers, through: :questions, dependent: :destroy
  accepts_nested_attributes_for :questions

  validates :title,
            presence: true,
            uniqueness: true,
            length: { maximum: 30 }

  validates :content,
            presence: true,
            length: { maximum: 60 }
end
