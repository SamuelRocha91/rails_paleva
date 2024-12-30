FactoryBot.define do
  factory :menu do
    name { Faker::Food.ethnic_category }
    establishment
  end
end
