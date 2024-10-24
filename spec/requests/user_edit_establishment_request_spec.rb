require 'rails_helper'

describe 'Usuário edita um restaurante' do 
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
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuelson@hotmail.com', 
      password: '12345678910111',  
      cpf: CPF.generate
    )
    establishment = Establishment.new(
      email:'sam@gmail.com', 
      trade_name: 'Samsumg', 
      legal_name: 'Samsumg LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas' 
    )

    establishment_two = Establishment.new(
      email:'samsdsdsds@gmail.com', 
      trade_name: 'LG RANGOS', 
      legal_name: 'La ra LTSA', 
      cnpj: '51573271000177',
      phone_number: '71992194946', 
      address: 'Rua das Alamedas  d dsdavenidas' 
    )
    operating_hour = []
    operating_hour_two = []
    7.times { |i| operating_hour << OperatingHour.new(week_day: i, is_closed: true)}
    7.times { |i| operating_hour_two << OperatingHour.new(week_day: i, is_closed: true)}

    establishment.operating_hours = operating_hour
    user.establishment = establishment
    establishment_two.operating_hours = operating_hour_two
    user_two.establishment = establishment_two
    # Act
    login_as(user_two)
    patch(establishment_path(establishment.id), params: { establishment: { phone_number: '85992554946'}})
    # Assert
    expect(response).to redirect_to(root_path)
  end
end