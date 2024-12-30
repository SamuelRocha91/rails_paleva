FactoryBot.define do
  factory :customer do
    name { Faker::Name.first_name }
    cpf { Faker::IdNumber.brazilian_citizen_number }
    email { Faker::Internet.email }
    phone_number { '71992594946' }
  end
end
