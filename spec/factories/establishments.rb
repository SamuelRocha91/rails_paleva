FactoryBot.define do
  factory :establishment do
    trade_name { Faker::Company.name }
    legal_name { Faker::Company.industry }
    cnpj { '56924048000140' }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.cell_phone }
    address { Faker::Address.street_address }
  end
end
