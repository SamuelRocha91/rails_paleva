require 'rails_helper'

describe 'Usuário edita uma bebida' do 
  it 'e não é o dono' do 
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )

    user_two = User.create!(
      first_name: 'Bill', 
      last_name: 'Gates', 
      email: 'ng@hotmail.com', 
      password: '12345678910111',  
      cpf: CPF.generate
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

    Establishment.create!(
      email: 'bill@gmail.com', 
      trade_name: 'Microsoft', 
      legal_name: 'Microsoft LTDA', 
      cnpj: '12345678000195',
      phone_number: '71992594950', 
      address: 'Rua da Microsoft',
      user: user_two
    )


    beverage = Beverage.create!(
      name: 'cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )
    # Act
    login_as(user_two)
    patch(establishment_beverage_path(establishment.id, beverage.id), 
            params: { beverage: { name: 'Coca-cola'}})
    # Assert
    expect(response).to redirect_to(root_path)
  end
end