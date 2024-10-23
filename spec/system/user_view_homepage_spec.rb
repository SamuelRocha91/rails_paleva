require 'rails_helper'

describe "Usuário acessa a aplicação" do
  it 'não logado é direcionado para a página de login' do
    # Act
    visit root_path
    # Assert
    expect(current_path).to eq new_user_session_path 
  end

  it 'sem estabelecimento cadastrado é direcionado para cadastrar' do
    # Arrange
    User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    # Act
    visit root_path
    fill_in "E-mail",	with: "samuel@hotmail.com" 
    fill_in "Senha",	with: "12345678910111"
    click_on 'Entrar'
    # Assert
    expect(current_path).to eq new_establishment_path
  end

  it 'sem estabelecimento não consegue acessar outra rota' do
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
    expect(page).to have_content 'Você precisa criar um estabelecimento antes de continuar.' 
  end
end
