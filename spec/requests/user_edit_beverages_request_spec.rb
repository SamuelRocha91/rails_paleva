require 'rails_helper'

describe 'Usuário edita uma bebida' do
  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    beverage = create(:beverage, name: 'cachaça', establishment: establishment)

    # Act
    login_as user
    patch(establishment_beverage_path(establishment.id, beverage.id),
          params: { beverage: { name: 'Coca-cola' } })

    # Assert
    expect(response).to redirect_to(root_path)
  end

  it 'e não é o dono' do
    # Arrange
    establishment = create(:establishment)
    create(:user, :employee, establishment: establishment)
    user_two = User.create!(first_name: 'Bill', last_name: 'Gates', email: 'ng@hotmail.com', password: '12345678910111',
                            cpf: CPF.generate)
    beverage = create(:beverage, name: 'cachaça', establishment: establishment)

    # Act
    login_as(user_two)
    patch(establishment_beverage_path(establishment.id, beverage.id),
          params: { beverage: { name: 'Coca-cola' } })

    # Assert
    expect(response).to redirect_to(root_path)
  end
end
