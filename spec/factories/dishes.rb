FactoryBot.define do
  factory :dish do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    calories { '569' }
    status { true }
    establishment
  end
end
