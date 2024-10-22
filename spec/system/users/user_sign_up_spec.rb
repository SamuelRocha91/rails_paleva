require 'rails_helper'

describe 'Usuário que não é ainda cadastrado' do
  it 'consegue acessar a página de cadastro' do
    # Arrange
    # Act
    visit root_path
    click_on 'Criar conta'
    # Assert
    expect(current_path).to eq new_user_registration_path
    expect(page).to have_content 'E-mail'
    expect(page).to have_content 'Senha'
    expect(page).to have_content 'Confirme sua senha'
    expect(page).to have_content 'CPF'
    expect(page).to have_content 'Nome'
    expect(page).to have_content 'Sobrenome'
  end
end