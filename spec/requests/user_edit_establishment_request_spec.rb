require 'rails_helper'

describe 'Usuário edita um restaurante' do
  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    operating_hour = []
    7.times do |i|
      operating_hour << OperatingHour
                        .new(week_day: i, is_closed: true)
    end
    establishment.operating_hours = operating_hour

    # Act
    login_as user
    patch(establishment_path(establishment.id),
          params: { establishment: { phone_number: '85992554946' } })

    # Assert
    expect(response).to redirect_to(root_path)
  end

  it 'e não é o dono' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    user_two = User.create!(first_name: 'Bill', last_name: 'Gates', email: 'ng@hotmail.com', password: '12345678910111',
                            cpf: CPF.generate)
    operating_hour = []
    7.times do |i|
      operating_hour << OperatingHour
                        .new(week_day: i, is_closed: true)
    end
    establishment.operating_hours = operating_hour

    # Act
    login_as(user_two)
    patch(establishment_path(establishment.id),
          params: { establishment: { phone_number: '85992554946' } })

    # Assert
    expect(response).to redirect_to(establishments_path)
  end
end
