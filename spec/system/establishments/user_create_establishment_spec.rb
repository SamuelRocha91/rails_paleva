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
    expect(page).to have_content 'Horário de funcionamento'
    expect(page).to have_selector 'label', text: 'Domingo'
    expect(page).to have_selector 'label', text: 'Segunda'
    expect(page).to have_selector 'label', text: 'Terça'
    expect(page).to have_selector 'label', text: 'Quarta'
    expect(page).to have_selector 'label', text: 'Quinta'
    expect(page).to have_selector 'label', text: 'Sexta'
    expect(page).to have_selector  'label', text: 'Sábado'
    expect(page).to have_button 'Cadastrar'
  end

  it 'tem cadastro recusado por falta de campo obrigatório' do
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
    fill_in 'Nome Social',	with: 'Comidícia'
    fill_in 'CNPJ',	with: '56924048000140'
    fill_in 'Endereço',	with: 'Rua da Fome, 100'
    click_on 'Cadastrar'
    # Assert
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
  end
end