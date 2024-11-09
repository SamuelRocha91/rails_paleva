require 'rails_helper'

describe 'Usuário acessa página para desativar oferta de um prato' do
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
    dish = Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )

    # Act
    visit establishment_dish_path(establishment.id, dish.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e desativa com sucesso' do
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
    dish = Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )
    format = Format.create!(name: 'Porção Giga gante')
    format_two = Format.create!(name: 'Porção pequena')

    Offer.create!(
      format: format,
      item: dish,
      price: 25
    )
    Offer.create!(
      format: format_two,
      item: dish,
      price: 33
    )

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    find('button.Porção-Giga-gante').click
    # Assert
    expect(page).not_to have_content 'Porção Giga gante: R$ 25,00'
    expect(page).to have_content 'Porção pequena: R$ 33,00'
  end
end