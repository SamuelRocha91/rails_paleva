require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    # ACT
    visit new_order_path
    # Assert
    expect(current_path).to eq new_user_session_path  
  end


  it 'e visualiza página de cadastro de observações' do
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
    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
    Menu.create!(establishment: establishment, name: 'Almoço')

    dish = Dish.create!(
          name: 'lasagna', 
          description: 'massa, queijo e presunto', 
          calories: '185', 
          establishment: establishment
    )

    format = Format.create!(name: 'Porção grande')
    format_two = Format.create!(name: 'Porção média')

    Offer.create!(
      format: format,
      item: dish,
      price: 55
    )
    Offer.create!(
      format: format_two,
      item: dish,
      price: 25
    )

    MenuItem.create!(item: dish, menu: menu)

    # Act
    login_as user
    visit root_path
    click_on 'Café da manhã'
    save_page
    find('.Porção-grande-lasagna').click
    save_page
    # Assert
    expect(page).to have_content  'Adicionar Porção ao Pedido'
    expect(page).to have_field 'Observação'
    expect(page).to have_button 'Adicionar ao Pedido'
  end

  it 'e adiciona item ao pedido' do
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
    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
    Menu.create!(establishment: establishment, name: 'Almoço')

    dish = Dish.create!(
          name: 'lasagna', 
          description: 'massa, queijo e presunto', 
          calories: '185', 
          establishment: establishment
    )

    format = Format.create!(name: 'Porção grande')
    format_two = Format.create!(name: 'Porção média')

    Offer.create!(
      format: format,
      item: dish,
      price: 55
    )
    Offer.create!(
      format: format_two,
      item: dish,
      price: 25
    )

    MenuItem.create!(item: dish, menu: menu)

    # Act
    login_as user
    visit root_path
    click_on 'Café da manhã'
    save_page
    find('.Porção-grande-lasagna').click
    fill_in 'Observação',	with: 'Sem cebola' 
    click_on 'Adicionar ao Pedido'

    # Assert
    expect(page).to have_content 'Visualizar Pedido'
    expect(page).to have_content 'Porção grande - lasagna - R$ 55,00 - Observação: Sem cebola'
    expect(page).to have_link 'Finalizar Pedido'
    expect(page).to have_content 'Continuar adicionando itens'
  end

end