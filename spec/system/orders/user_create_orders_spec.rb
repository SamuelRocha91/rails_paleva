require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    # ACT
    visit new_order_path
    # Assert
    expect(current_path).to eq new_user_session_path  
  end

  it 'com e visualiza campos corretamente' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )

    Establishment.create!(
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
    click_on 'Registrar pedido'

    # Assert
    expect(page).to have_content 'E-mail'
    expect(page).to have_content 'CPF'
    expect(page).to have_content 'Telefone'
    expect(page).to have_content 'Nome do cliente'
    expect(page).to have_button 'Salvar'  
  end
end