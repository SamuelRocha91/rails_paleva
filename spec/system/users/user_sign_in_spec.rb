require 'rails_helper'

describe 'Usuário acessa página de login' do
  it 'e faz login com sucesso' do
    # Arrange
    user = User.create!(first_name: 'Samuel', last_name: 'Rocha', email: 'samuel@hotmail.com', password: '12345678910111',  cpf: '03466588911')
    # Act
    visit root_path
    fill_in "E-mail",	with: "samuel@hotmail.com" 
    fill_in "Senha",	with: "12345678910111"
    click_on 'Login'
    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content "#{user.first_name} #{user.last_name} - #{user.email}"
  end
end