# frozen_string_literal: true

FactoryBot.define do
  factory :problems_tag do
    trait :with_problem do
      association :problem
    end

    trait :with_tag do
      association :tag
    end
  end
end
