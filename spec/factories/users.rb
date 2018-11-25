FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    school { 'テスト学校' }
    role { 1 }
    sequence(:login_id) { |n| "test_user#{n}" }
    password { '12345678' }
    password_confirmation { '12345678' }

    factory :student do
      name { 'テスト生徒' }
      role { 0 }
      sequence(:login_id) { |n| "test_student#{n}" }
    end

    factory :teacher do
      name { 'テスト講師' }
      role { 1 }
      sequence(:login_id) { |n| "test_teacher#{n}" }
    end
  end
end
