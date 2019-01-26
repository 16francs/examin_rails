# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sentence { '問題' }
    correct { '答え' }

    trait :with_problem do
      association :problem
    end
  end
end
