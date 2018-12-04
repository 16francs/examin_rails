class Problem < ApplicationRecord
  self.table_name = 'problems'
  belongs_to :user, optional: true
  has_many :problems_users, dependent: :delete_all
  has_many :users, through: :problems_users
  has_many :questions, dependent: :delete_all
  accepts_nested_attributes_for :questions

  validates :title,
            presence: true,
            length: { maximum: 30 }

  validates :content,
            presence: true,
            length: { maximum: 60 }
end
