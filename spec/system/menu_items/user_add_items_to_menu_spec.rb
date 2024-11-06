require 'rails_helper'

describe 'Usuário acessa formulário de cadastro de item para um cardápio' do
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

    menu = Menu.create!(
      establishment: establishment, 
      name: 'Café da manhã'
    )

    # Act
    visit new_menu_menu_item_path menu

    # Assert
    expect(current_path).to eq new_user_session_path
  end
end