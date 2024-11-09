require 'rails_helper'

describe 'Usuário acessa página de estabelecimento' do
  it 'e deve estar autenticado' do
    # Act
    visit establishments_path

    # Assert
    expect(current_path).to eq new_user_session_path  
  end

  it 'com sucesso' do
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
      establishment: establishment
    )

    operating_hour = []
    6.times { |i| operating_hour << OperatingHour
                                      .new(week_day: i, is_closed: true)}
    operating_hour <<  OperatingHour.new(
      week_day: 6, 
      start_time: Time.zone.parse('08:00'), 
      end_time: Time.zone.parse('22:00'), 
      is_closed: false
    )
    
    establishment.operating_hours = operating_hour
 
    # Act
    login_as user
    visit root_path
    click_on establishment.trade_name

    # Assert
    expect(page).to have_content 'Nome Social: Samsung'
    expect(page).to have_content "Código: #{establishment.code}"
    expect(page).to have_content 'CNPJ: 56.924.048/0001-40'
    expect(page).to have_content 'Telefone: (71) 99259-4946'
    expect(page).to have_content 'Endereço: Rua das Alamedas avenidas'
    expect(page).to have_content 'Segunda: Fechado'
    expect(page).to have_content 'Terça: Fechado'
    expect(page).to have_content 'Quarta: Fechado'
    expect(page).to have_content 'Quinta: Fechado'
    expect(page).to have_content 'Sexta: Fechado'
    expect(page).to have_content 'Sábado: 08:00 - 22:00'
    expect(page).to have_content 'Domingo: Fechado'
    expect(page).to have_link 'Editar informações'
  end
end