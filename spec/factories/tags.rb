# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    sequence(:content) { |n| "タグ#{n}" }
  end
end
