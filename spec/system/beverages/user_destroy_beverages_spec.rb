require 'rails_helper'

describe 'Usuário deleta um prato' do
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
      name: 'cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )
    
    # Act
    visit establishment_dish_path(establishment.id, beverage.id)
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

    Beverage.create!(
      name: 'cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )

    Beverage.create!(
      name: 'Suco de goiaba', 
      description: 'agua vegana', 
      calories: '17', 
      establishment: establishment, 
      is_alcoholic: true
    )
    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Suco de goiaba'
    click_on 'Excluir bebida'
    # Assert
    expect(page).to have_content 'Registro excluído com sucesso'
    expect(page).not_to have_content 'Suco de goiaba'
    expect(page).not_to have_content 'agua vegana'
  end
end