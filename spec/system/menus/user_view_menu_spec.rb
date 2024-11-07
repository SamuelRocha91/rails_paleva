require 'rails_helper'

describe 'Usuário acessa página de visualização individual de cardápio' do
  it 'e deve estar autenticado' do
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

    menu = Menu.create!(
      establishment: establishment, 
      name: 'Café da manhã'
    )

    # Act
    visit menu_path menu.id

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e visualiza pratos com itens e porções' do
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

    menu = Menu.create!(
      establishment: establishment, 
      name: 'Café da manhã'
    )

    beverage = Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )
    format = Format.create!(name: 'Bombinha 50ml')
    Offer.create!(
      format: format,
      item: beverage,
      price: 25
    )

    dish = Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )
    format_two = Format.create!(name: 'Giga gante')
    format_three = Format.create!(name: 'média')
    Offer.create!(
      format: format_two,
      item: dish,
      price: 27
    )
    Offer.create!(
      format: format_three,
      item: dish,
      price: 12
    )

    MenuItem.create!(item: dish, menu: menu)
    MenuItem.create!(item: beverage, menu: menu)

    # Act
    login_as user
    visit root_path
    click_on 'Café da manhã'

    # Assert
    expect(page).to have_content 'Cardápio: Café da manhã'
    expect(page).to have_content 'Prato: lasagna'
    expect(page).to have_content 'Bebida: Cachaça'
    expect(page).to have_content 'Volume Bombinha 50ml: R$ 25,00'
    expect(page).to have_content 'Porção Giga gante: R$ 27,00'
    expect(page).to have_content 'Porção média: R$ 12,00'
  end
end