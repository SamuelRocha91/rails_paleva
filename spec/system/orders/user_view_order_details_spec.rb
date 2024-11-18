require 'rails_helper'

describe 'Usuário acompanha um pedido' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
    )
    customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
    order = Order.create!(establishment: establishment, customer: customer)

    # Act
    visit order_path order.id

    # Assert
    expect(current_path).to eq new_user_session_path  
  end

  it 'com sucesso' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
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
    menu = Menu.create!(
      establishment: establishment, 
      name: 'Café da manhã'
    )
    MenuItem.create!(item: dish, menu: menu)


    OrderItem.create!(offer: offer, order: order )

    # Act
    login_as user
    visit root_path
    click_on 'Pedidos'
    click_on order.code

    # Assert
    expect(page).to have_content 'Pedido'
    expect(page).to have_content 'Dados do cliente'
    expect(page).to have_content 'Nome do cliente: Samuel'    
    expect(page).to have_content 'E-mail: sam@gmail.com'
    expect(page).to have_content 'Porção grande - R$ 55,00'
    expect(page).to have_content 'Nome do prato: lasagna'
    expect(page).to have_content 'Status: Aguardando confirmação da cozinha'
    expect(page).to have_content 'Total: R$ 55,00'
    expect(page).to have_button 'Marcar como Cancelado'
    expect(page).to have_button 'Marcar como EM PREPARO'
  end
end