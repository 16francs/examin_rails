# frozen_string_literal: true

FactoryBot.define do
  factory :achievement do
    result { true }
    user_choice { 1 }
    answer_time { 10 }

    trait :with_problems_user do
      association :problems_user
    end

    trait :with_question do
      association :question
    end
  end
end
