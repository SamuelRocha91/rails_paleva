require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it 'Não é possível vincular um item que não faz parte de um cardápio' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    beverage = create(:beverage, establishment: establishment)
    customer = Customer.create!(name: 'Tupã', email: 'cacique@gmail.com')
    order = Order.new(establishment: establishment, customer: customer)
    format = Format.create!(name: 'Bombinha 50ml')
    offer = Offer.create!(format: format, item: beverage, price: 25)
    order_item = OrderItem.new(offer: offer, note: 'Sem água', order: order)

    # Act
    result = order_item.valid?

    # Assert
    expect(result).to eq false
  end
end
