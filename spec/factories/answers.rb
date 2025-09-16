FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    association :user

    trait :invalid_answer do
      body { nil }
    end
  end
end
