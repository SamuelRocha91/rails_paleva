require 'rails_helper'

describe 'Usuário vê suas próprias bebidas' do

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
    Beverage.create!(
      name: 'cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )
    
    # Act
    login_as user
    visit establishment_beverages_path(establishment.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e navega para a página de detalhes' do
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

    beverage.image.attach(
      io: File.open(Rails.root.join('spec', 'support', 'pao.jpg')),
      filename: 'pao.jpg'
    )

    Beverage.create!(
      name: 'Suco da embasa', 
      description: 'Água que mata a sede', 
      calories: '1', 
      establishment: establishment, 
      is_alcoholic: false
    )

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'

    # Assert
    expect(current_path).to eq establishment_beverage_path(establishment.id, beverage.id)
    expect(page).to have_content 'Nome: Cachaça'
    expect(page).to have_content 'Descrição: alcool delicioso baiano'
    expect(page).to have_css('img[src*="pao.jpg"]')
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_content 'É alcoólica? Sim'
    expect(page).to have_link 'Cadastrar volume'
    expect(page).to have_link 'Editar bebida'  
  end 

  it 'e não vê bebidas de outros estabelecimentos' do
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

    establishment_two = Establishment.create!(
      email: 'bill@gmail.com', 
      trade_name: 'Microsoft', 
      legal_name: 'Microsoft LTDA', 
      cnpj: '12345678000195',
      phone_number: '71992594950', 
      address: 'Rua da Microsoft',
    )

    User.create!(
      first_name: 'Bill', 
      last_name: 'Gates', 
      email: 'ng@hotmail.com', 
      password: '12345678910111',  
      cpf: CPF.generate,
      establishment: establishment_two
    )

    beverage = Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )
    
    beverage.image.attach(
      io: File.open(Rails.root.join('spec', 'support', 'pao.jpg')), 
      filename: 'pao.jpg'
    )

    Beverage.create!(
      name: 'Chimarrão', 
      description: 'mate com agua', 
      calories: '15', 
      establishment: establishment, 
      is_alcoholic: true
    )

    Beverage.create!(
      name: 'Suco da embasa', 
      description: 'Água que mata a sede', 
      calories: '1', 
      establishment: establishment_two, 
      is_alcoholic: false
    )
    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'

    # Assert
    expect(page).to have_content 'Nome: Cachaça'
    expect(page).to have_content 'Descrição: alcool delicioso baiano'
    expect(page).not_to have_content 'Nome: Suco da embasa'
    expect(page).not_to have_content 'Descrição: Água que mata a sede'
  end

   it 'e não página de deetalhes de bebidas de outros estabelecimentos' do
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

    establishment_two = Establishment.create!(
      email: 'bill@gmail.com', 
      trade_name: 'Microsoft', 
      legal_name: 'Microsoft LTDA', 
      cnpj: '12345678000195',
      phone_number: '71992594950', 
      address: 'Rua da Microsoft',
    )

    User.create!(
      first_name: 'Bill', 
      last_name: 'Gates', 
      email: 'ng@hotmail.com', 
      password: '12345678910111',  
      cpf: CPF.generate,
      establishment: establishment_two
    )

    beverage = Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )
    beverage.image.attach(
      io: File.open(Rails.root.join('spec', 'support', 'pao.jpg')), 
      filename: 'pao.jpg'
    )

    Beverage.create!(
      name: 'Chimarrão', 
      description: 'mate com agua', 
      calories: '15',
      establishment: establishment,
      is_alcoholic: true
    )

    beverage_two = Beverage.create!(
      name: 'Suco da embasa',
      description: 'Água que mata a sede', 
      calories: '1', 
      establishment: establishment_two,
      is_alcoholic: false
    )
    # Act
    login_as user
    visit establishment_beverage_path(establishment_two, beverage_two)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa bebida'
  end 
end