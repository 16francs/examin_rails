# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    school { 'テスト学校' }
    role { 1 }
    sequence(:login_id) { |n| "user#{n}" }
    password { '12345678' }
    password_confirmation { '12345678' }
    activated { true }

    factory :student do
      name { 'テスト生徒' }
      role { 0 }
      sequence(:login_id) { |n| "student#{n}" }
    end

    factory :teacher do
      name { 'テスト講師' }
      role { 1 }
      sequence(:login_id) { |n| "teacher#{n}" }
    end

    factory :admin do
      name { '管理者' }
      role { 2 }
      sequence(:login_id) { |n| "admin#{n}" }
    end
  end
end
