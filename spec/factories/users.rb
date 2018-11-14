FactoryBot.define do
  factory :user do
    sequence(:name) { 'テストユーザー' }
    sequence(:school) { 'テスト学校' }
    sequence(:role) { 1 }
    sequence(:login_id) { 'test_user' }
    sequence(:password) { '12345678' }
    sequence(:password_confirmation) { '12345678' }

    factory :student do
      sequence(:name) { 'テスト生徒' }
      sequence(:role) { 0 }
      sequence(:login_id) { |n| "test_student#{n}" }
    end

    factory :teacher do
      sequence(:name) { 'テスト講師' }
      sequence(:role) { 1 }
      sequence(:login_id) { |n| "test_teacher#{n}" }
    end
  end
end
