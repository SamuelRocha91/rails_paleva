require 'rails_helper'

describe 'Usuário edita um prato' do
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

    dish = Dish.create!(name: 'lasagna', description: 'pão com ovo', 
                 calories: '185', establishment: establishment)
    
    # Act
    visit edit_establishment_dish_path(establishment.id, dish.id)
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

    Dish.create!(name: 'lasagna', description: 'massa, queijo e presunto', 
                 calories: '185', establishment: establishment)
    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'
    click_on 'Editar prato'
    fill_in 'Nome',	with: 'Pão com ovo'
    fill_in 'Descrição',	with: 'ovo de galinha 10 reais'
    fill_in 'Quantidade de calorias',	with: '105'
    click_on 'Salvar'
    # Assert
    expect(page).to have_content 'Prato atualizado com sucesso'
    expect(page).to have_content 'Nome: Pão com ovo'
    expect(page).to have_content 'Descrição: ovo de galinha 10 reais'
    expect(page).not_to have_content 'lasagna'
    expect(page).not_to have_content 'massa, queijo e presunto'
  end
end