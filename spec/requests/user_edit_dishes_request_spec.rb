require 'rails_helper'

describe 'Usuário edita um prato' do
  it 'e deve ser :admin' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
    )
    user = User.create!(
      first_name: 'Samuel',
      last_name: 'Rocha',
      email: 'samuel@hotmail.com',
      password: '12345678910111',
      cpf: '22611819572',
      establishment: establishment,
      role: 1
    )

    dish = Dish.create!(
      name: 'lasagna',
      description: 'pão com ovo',
      calories: '185',
      establishment: establishment
    )

    # Act
    login_as user
    patch(establishment_dish_path(establishment.id, dish.id),
          params: { dish: { name: 'Feijoada' } })

    # Assert
    expect(response).to redirect_to(root_path)
  end

  it 'e não é o dono' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
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

    dish = Dish.create!(
      name: 'lasagna',
      description: 'pão com ovo',
      calories: '185',
      establishment: establishment
    )

    # Act
    login_as(user_two)
    patch(establishment_dish_path(establishment.id, dish.id),
          params: { dish: { name: 'Feijoada' } })

    # Assert
    expect(response).to redirect_to(root_path)
  end
end
