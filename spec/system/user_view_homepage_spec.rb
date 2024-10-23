require 'rails_helper'

describe "Usuário acessa a aplicação" do
  it 'não logado é direcionado para a página de login' do
    # Act
    visit root_path
    # Assert
    expect(current_path).to eq new_user_session_path 
  end

  it 'autenticado e sem restaurante cadastrado' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel',
      last_name: 'Rocha',
      email: 'samuel@hotmail.com',
      password: '12345678910111',
      cpf: CPF.generate.to_s
    )
    # Act
    login_as(user)
    visit root_path
    # Assert
    expect(current_path).to eq '/establishment/new'
  end
end
