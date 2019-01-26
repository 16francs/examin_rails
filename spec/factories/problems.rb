# frozen_string_literal: true

FactoryBot.define do
  factory :problem do
    title { 'タイトル' }
    content { '概要' }

    trait :with_user do
      association :user
    end
  end
end
