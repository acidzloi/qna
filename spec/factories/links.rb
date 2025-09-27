FactoryBot.define do
  factory :link do
    name { "Url" }
    url { "https://test.local" }
  end
  
  trait :gist_link do
    name { "Gist" }
    url { "https://gist.github.com" }  
  end
end
