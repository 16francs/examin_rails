FactoryBot.define do
  factory :achievement do
    result { true }
    user_choice { -1 }

    trait :with_problems_user do
      association :problems_user, :with_problem, :with_user
    end

    trait :with_question do
      association :question, :with_problem
    end
  end
end
