require 'rails_helper'

describe 'Usuário edita uma bebida' do 
  it 'e não é o dono' do 
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
    )

    user_two = User.create!(
      first_name: 'Bill', 
      last_name: 'Gates', 
      email: 'ng@hotmail.com', 
      password: '12345678910111',  
      cpf: CPF.generate
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