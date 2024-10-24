require 'rails_helper'

describe 'Usuário acessa formulário de criar pratos' do
  it 'e deve estar autenticado' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    establishment = Establishment.new(
      email:'sam@gmail.com', 
      trade_name: 'Samsumg', 
      legal_name: 'Samsumg LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas' 
    )
    operating_hour = []
    6.times { |i| operating_hour << OperatingHour.new(week_day: i, is_closed: true)}
    operating_hour <<  OperatingHour.new(week_day: 6, start_time: Time.zone.parse('08:00'), end_time: Time.zone.parse('22:00'), is_closed: false)
    establishment.operating_hours = operating_hour
    establishment.save
    user.establishment = establishment 
    # Act
    visit new_establishment_dish_path establishment.id
    # Assert
    expect(current_path).to eq new_user_session_path  
  end
end
