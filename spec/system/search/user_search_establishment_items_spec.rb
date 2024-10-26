require 'rails_helper'

describe 'Usuário busca por um item' do
  it 'a partir do menu' do
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
    login_as(user)
    visit root_path
    # Assert
    within('header') do
      expect(page).to have_field 'Buscar Item'
      expect(page).to have_select('type', with_options: ['Bebida', 'Comida', 'Ambos'])
      expect(page).to have_button 'Pesquisar'  
    end
  end
end