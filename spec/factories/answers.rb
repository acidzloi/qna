FactoryBot.define do
  factory :answer do
    body { "MyText" }

    trait :invalid_answer do
      body { nil }
    end
  end
end
