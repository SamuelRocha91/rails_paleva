require 'rails_helper'

describe 'Usuário acessa formulário de criar oferta de uma bebida' do
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
    beverage = Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )

    # Act
    visit offer_beverage_path(beverage.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e vê os campos corretamente' do
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
    Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    click_on 'Cadastrar volume'

    # Assert
    expect(page).to have_content 'Cadastro de volume de Cachaça'
    expect(page).to have_field 'Nome do volume'
    expect(page).to have_field 'Detalhes do volume'
    expect(page).to have_field 'Preço do volume'
    expect(page).to have_button 'Salvar'
  end

  it 'falha por ausência de campo obrigatório' do
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
    Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    click_on 'Cadastrar volume'
    fill_in 'Detalhes do volume',	with: 'bombinha de um só'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome da porção não pode ficar em branco'
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
    Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    click_on 'Cadastrar volume'
    fill_in 'Detalhes do volume',	with: 'bombinha de um só'
    fill_in 'Nome do volume',	with: 'Bombinha 50ml'
    fill_in 'Preço',	with: '50'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Volume cadastrado com sucesso'
    expect(page).to have_content 'Volumes Disponíveis' 
    expect(page).to have_content 'Volume Bombinha 50ml: R$ 50,00'
    expect(page).to have_link 'Editar Preço'  
    expect(page).to have_button 'Retirar Oferta' 
  end

end