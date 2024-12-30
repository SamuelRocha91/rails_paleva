FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    cpf { Faker::IdNumber.brazilian_citizen_number }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 12) }
    establishment

    trait :within_establishment do
      establishment_id { nil }
    end

    trait :employee do
      role { 1 }
    end
  end
end
