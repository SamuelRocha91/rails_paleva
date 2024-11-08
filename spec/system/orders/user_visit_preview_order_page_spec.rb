require 'rails_helper'

describe 'Usuário acessa página de pré-visualização de pedido' do
  it 'e deve estar autenticado' do
    # Act
    visit preview_order_path

    # Assert
    expect(current_path).to eq new_user_session_path  
  end

  it 'sem itens adicionados' do
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
    find('.icon-preview').click

    # Assert
    expect(page).to have_content 'Nenhum item foi adicionado ao pedido ainda.'
  end
end