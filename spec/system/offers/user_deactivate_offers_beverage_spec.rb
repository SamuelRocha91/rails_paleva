require 'rails_helper'

describe 'Usuário acessa página para desativar oferta de uma bebida' do
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

    # Act
    visit establishment_beverage_path(establishment.id, beverage.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser :admin' do
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
      establishment: establishment,
      role: 1
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

    # Act
    login_as user
    visit establishment_beverage_path(establishment.id, beverage.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
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
    beverage = Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )
    format = Format.create!(name: 'Bombinha 50ml')
    format_two = Format.create!(name: 'Bombinha 1l')

    Offer.create!(
      format: format,
      item: beverage,
      price: 25
    )

    Offer.create!(
      format: format_two,
      item: beverage,
      price: 33
    )

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    find('button.Bombinha-50ml').click

    # Assert
    expect(page).not_to have_content 'Volume Bombinha 50ml: R$ 50,00'
    expect(page).to have_content 'Volume Bombinha 1l: R$ 33,00'
  end
end