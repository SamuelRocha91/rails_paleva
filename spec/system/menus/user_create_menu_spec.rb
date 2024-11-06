require 'rails_helper'

describe 'Usuário acessa formulário de cadastro de cardápio' do
  it 'e deve estar autenticado' do
    # Act
    visit new_menu_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e visualiza campos corretamente' do
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

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    # Assert
    expect(page).to have_content 'Cadastro de Cardápio'
    expect(page).to have_field 'Nome do Cardápio'
    expect(page).to have_button 'Salvar'
  end

  it 'e falha ao tentar cadastrar sem nome' do
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

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    click_on 'Salvar'
    # Assert
    expect(page).to have_content 'Nome do Cardápio não pode ficar em branco'
  end
end