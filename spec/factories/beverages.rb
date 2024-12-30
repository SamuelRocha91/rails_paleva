FactoryBot.define do
  factory :beverage do
    name { Faker::Beer.brand }
    description { Faker::Beer.style }
    is_alcoholic { false }
    calories { '500' }
    status { true }
    establishment

    trait :alcoholic do
      is_alcoholic { true }
    end
  end
end
