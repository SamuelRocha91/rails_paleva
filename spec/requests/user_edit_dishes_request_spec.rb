require 'rails_helper'

describe 'Usuário edita um prato' do
  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)

    # Act
    login_as user
    patch(establishment_dish_path(establishment.id, dish.id),
          params: { dish: { name: 'Feijoada' } })

    # Assert
    expect(response).to redirect_to(root_path)
  end

  it 'e não é o dono' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    user_two = User.create!(first_name: 'Bill', last_name: 'Gates', email: 'ng@hotmail.com', password: '12345678910111',
                            cpf: CPF.generate)
    dish = create(:dish, name: 'lasagna', establishment: establishment)

    # Act
    login_as(user_two)
    patch(establishment_dish_path(establishment.id, dish.id),
          params: { dish: { name: 'Feijoada' } })

    # Assert
    expect(response).to redirect_to(root_path)
  end
end
