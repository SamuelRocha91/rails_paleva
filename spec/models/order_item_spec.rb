require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it 'Não é possível vincular um item que não faz parte de um cardápio' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
    )
    User.create!(
      first_name: 'Samuel',
      last_name: 'Rocha',
      email: 'samuel@hotmail.com',
      password: '12345678910111',
      cpf: '22611819572',
      establishment: establishment,
      role: 1
    )

    beverage = Beverage.create!(
      name: 'cachaça',
      description: 'alcool delicioso baiano',
      calories: '185',
      establishment: establishment,
      is_alcoholic: true
    )

    customer = Customer.create!(name: 'Tupã', email: 'cacique@gmail.com')

    order = Order.new(establishment: establishment, customer: customer)

    format = Format.create!(name: 'Bombinha 50ml')
    offer = Offer.create!(
      format: format,
      item: beverage,
      price: 25
    )

    order_item = OrderItem.new(
      offer: offer,
      note: 'Sem água',
      order: order
    )

    # Act
    result = order_item.valid?

    # Assert
    expect(result).to eq false
  end
end
