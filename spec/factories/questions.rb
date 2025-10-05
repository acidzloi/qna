FactoryBot.define do
  factory :question do
    title { "MyQuestionTitle" }
    body { "MyQuestionBody" }
    association :user

factory :question_with_file do
      after(:create) do |question|
        question.files.attach(io: File.open(Rails.root.join('public/icon.png')),
                              filename: 'icon.png',
                              content_type: 'image/png')
      end
    end


    trait :invalid do
      title { nil }
    end
  end
end
