FactoryBot.define do
  factory :answer do
    choice { '答え' }

    trait :with_question do
      association :question, :with_problem
    end
  end
end
