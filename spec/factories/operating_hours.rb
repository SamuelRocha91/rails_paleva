FactoryBot.define do
  factory :operating_hour do
    week_day { 0 }
    start_time { Faker::Time.between(from: '08:00', to: '10:00') }
    end_time { Faker::Time.between(from: '18:00', to: '20:00') }
    is_closed { false }
    establishment

    trait :closed do
      is_closed { true }
      start_time { nil }
      end_time { nil }
    end
  end
end
