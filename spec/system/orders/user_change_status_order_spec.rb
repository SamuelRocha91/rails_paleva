require 'rails_helper'

describe 'Usuário muda status do pedido' do
  it 'e deve estar autenticado' do
    # ACT
    visit orders_path
    # Assert
    expect(current_path).to eq new_user_session_path  
  end

  it 'de aguardando confirmação da cozinha PARA em preparo' do
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
    Order.create!(establishment: establishment, customer: customer_two)

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
    click_on order.code
    click_on 'Marcar como EM PREPARO'


    # Assert
    expect(page).to have_content 'Status do Pedido atualizado com sucesso'
    within('table') do
      expect(page).to have_content 'Em preparação'  
    end  
  end

  it 'de em preparo PARA pronto para entrega' do
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

    order = Order.create!(establishment: establishment, customer: customer, status: 2)
    Order.create!(establishment: establishment, customer: customer_two)

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
    click_on order.code
    click_on 'Marcar como PRONTO PARA ENTREGA'

    # Assert
    expect(page).to have_content 'Status do Pedido atualizado com sucesso'
    within('table') do
      expect(page).to have_content 'Pronto para entrega'  
    end  
  end

  it 'de pronto para entrega PARA entregue' do
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

    order = Order.create!(establishment: establishment, customer: customer, status: 5)
    Order.create!(establishment: establishment, customer: customer_two)

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
    click_on order.code
    click_on 'Marcar como ENTREGUE'

    # Assert
    expect(page).to have_content 'Status do Pedido atualizado com sucesso'
    within('table') do
      expect(page).to have_content 'Entregue'  
    end  
  end
end