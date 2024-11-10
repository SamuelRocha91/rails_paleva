require 'rails_helper'

describe 'Usuário edita um restaurante' do 
  it 'e deve ser :admin' do 
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
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

    operating_hour = []

    7.times { |i| operating_hour << OperatingHour
                                      .new(week_day: i, is_closed: true)}

    establishment.operating_hours = operating_hour

    # Act
    login_as user
    patch(establishment_path(establishment.id), 
            params: { establishment: { phone_number: '85992554946'}})

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

    operating_hour = []

    7.times { |i| operating_hour << OperatingHour
                                      .new(week_day: i, is_closed: true)}

    establishment.operating_hours = operating_hour

    # Act
    login_as(user_two)
    patch(establishment_path(establishment.id), 
            params: { establishment: { phone_number: '85992554946'}})

    # Assert
    expect(response).to redirect_to(establishments_path)
  end
end