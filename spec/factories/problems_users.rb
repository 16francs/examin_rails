FactoryBot.define do
  factory :problems_user do
    trait :with_problem do
      association :problem, :with_user
    end

    trait :with_user do
      association :user
    end
  end
end
