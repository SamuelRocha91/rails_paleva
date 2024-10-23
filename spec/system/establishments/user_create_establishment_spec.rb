require 'rails_helper'

describe 'Usuário acessa formulário de cadastro de estabelecimento' do
  it 'e deve estar autenticado' do
    # Act
    visit new_establishment_path
    # Assert
    expect(current_path).to eq new_user_session_path  
  end

  it 'e encontra todos dados de cadastro' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    # Act
    login_as user
    visit root_path
    # Assert
    expect(current_path).to eq new_establishment_path  
    expect(page).to have_content 'Cadastrar Restaurante'
    expect(page).to have_field 'Nome Social'
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Telefone'
    expect(page).to have_field 'E-mail'
    expect(page).to have_button 'Cadastrar'
  end
end