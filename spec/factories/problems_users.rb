# frozen_string_literal: true

FactoryBot.define do
  factory :questions_user do
    trait :with_problem do
      association :problem
    end

    trait :with_user do
      association :user
    end
  end
end
