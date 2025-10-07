FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    association :user
    association :question

    trait :invalid_answer do
      body { nil }
    end
  end
end
