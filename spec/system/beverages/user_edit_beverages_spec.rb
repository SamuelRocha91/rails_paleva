require 'rails_helper'

describe 'Usuário edita uma bebida' do
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

    beverage = Beverage.create!(name: 'cachaça', description: 'alcool delicioso baiano', 
                 calories: '185', establishment: establishment, is_alcoholic: true)
    
    # Act
    visit edit_establishment_beverage_path(establishment.id, beverage.id)
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

    Beverage.create!(name: 'cachaça', description: 'alcool delicioso baiano', 
                 calories: '185', establishment: establishment, is_alcoholic: true)
    
    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'cachaça'
    click_on 'Editar bebida'
    fill_in 'Nome',	with: 'Suco da embasa'
    fill_in 'Descrição',	with: 'aguinha que mata a sede'
    click_on 'Salvar'
    # Assert
    expect(page).to have_content 'Bebida atualizada com sucesso'
    expect(page).to have_content 'Nome: Suco da embasa'
    expect(page).to have_content 'Descrição: aguinha que mata a sede'
    expect(page).not_to have_content 'cachaça'
    expect(page).not_to have_content 'alcool delicioso baiano'
  end

  it 'Caso seja o responsável' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )

    user_two = User.create!(
      first_name: 'Bill', 
      last_name: 'Gates', 
      email: 'ng@hotmail.com', 
      password: '12345678910111',  
      cpf: CPF.generate
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

    Establishment.create!(
      email: 'bill@gmail.com', 
      trade_name: 'Microsoft', 
      legal_name: 'Microsoft LTDA', 
      cnpj: '12345678000195',
      phone_number: '71992594950', 
      address: 'Rua da Microsoft',
      user: user_two
    )

    beverage = Beverage.create!(name: 'cachaça', description: 'alcool delicioso baiano', 
                 calories: '185', establishment: establishment, is_alcoholic: true)
    # Act
    login_as user_two
    visit establishment_dish_path(establishment.id, beverage.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a esse prato'
  end
end