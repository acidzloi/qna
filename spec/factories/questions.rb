FactoryBot.define do
  factory :question do
    title { "MyQuestionTitle" }
    body { "MyQuestionBody" }
    association :user

    trait :invalid do
      title { nil }
    end
  end
end
