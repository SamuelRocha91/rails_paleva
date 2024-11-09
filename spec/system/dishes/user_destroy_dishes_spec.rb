require 'rails_helper'

describe 'Usuário deleta um prato' do
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
      description: 'pão com ovo', 
      calories: '185', 
      establishment: establishment
    )
    
    # Act
    visit establishment_dish_path(establishment.id, dish.id)
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

    Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )

    Dish.create!(
      name: 'Pão com ovos', 
      description: 'ovo de galinha 10 reais', 
      calories: '185', 
      establishment: establishment
    )

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Excluir prato'

    # Assert
    expect(page).to have_content 'Registro excluído com sucesso'
    expect(page).not_to have_content 'lasagna'
    expect(page).not_to have_content 'massa, queijo e presunto'
  end
end