FactoryBot.define do
  factory :temporary_user do
    cpf { Faker::IdNumber.brazilian_citizen_number }
    email { Faker::Internet.email }
    establishment
  end
end
