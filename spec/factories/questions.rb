FactoryBot.define do
  factory :question do
    sequence(:sentence) { |n| "問題文#{n}" }
    correct { '正解なし' }

    trait :with_problem do
      association :problem, :with_user
    end
  end
end
