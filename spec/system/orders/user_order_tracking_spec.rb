require 'rails_helper'

describe 'Usuário acompanha um pedido' do
  it 'e deve estar autenticado' do
    # ACT
    visit orders_path
    # Assert
    expect(current_path).to eq new_user_session_path  
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572'
    )
    establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
        user: user
    )

    customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
    customer_two = Customer.create!(name: 'Ana', email: 'ana@gmail.com')

    dish = Dish.create!(
          name: 'lasagna', 
          description: 'massa, queijo e presunto', 
          calories: '185', 
          establishment: establishment
    )
    format = Format.create!(name: 'Porção grande')

    order = Order.create!(establishment: establishment, customer: customer)
    order_two = Order.create!(establishment: establishment, customer: customer_two)

    offer = Offer.create!(
      format: format,
      item: dish,
      price: 55
    )

    OrderItem.create!(offer: offer, order: order )

    # Act
    login_as user
    visit root_path
    click_on 'Pedidos'

    # Assert
    within('table') do
      expect(page).to have_content 'Acompanhamento de pedidos'
      expect(page).to have_content 'Data'
      expect(page).to have_content 'Preço'    
      expect(page).to have_content 'Pedido'
      expect(page).to have_content 'Cliente'
      expect(page).to have_content 'Status'
      expect(page).to have_content 'R$ 55,00'
      expect(page).to have_content "#{order.code}"
      expect(page).to have_content "Aguardando confirmação da cozinha"
      expect(page).to have_content "#{order_two.code}"
    end 
  end
end