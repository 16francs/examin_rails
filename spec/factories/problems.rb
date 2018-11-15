FactoryBot.define do
  factory :problem do
    sequence(:title) { |n| "テスト問題集#{n}" }
    content { 'テスト詳細' }

    trait :with_user do
      association :user
    end
  end
end
