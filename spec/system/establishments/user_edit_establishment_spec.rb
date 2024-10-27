require 'rails_helper'

describe 'Usuário edita seu restabelecimento' do
  it 'a partir da página home' do
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
    login_as user
    visit root_path
    click_on 'Editar informações'
    # Assert
    expect(current_path).to eq edit_establishment_path establishment.id
    expect(page).to have_content 'Editar Restaurante'
    expect(page).to have_field 'Nome Social'
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Telefone'
    expect(page).to have_field 'E-mail'
    expect(page).to have_content 'Horário de funcionamento'
    expect(page).to have_content 'Domingo'
    expect(page).to have_content 'Segunda'
    expect(page).to have_content 'Terça'
    expect(page).to have_content 'Quarta'
    expect(page).to have_content 'Quinta'
    expect(page).to have_content 'Sexta'
    expect(page).to have_content 'Sábado'
    expect(page).to have_button 'Salvar'
  end

  it 'com dados incompletos' do
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
    operating_hour <<  OperatingHour.new(
      week_day: 6,
      start_time: Time.zone.parse('08:00'), 
      end_time: Time.zone.parse('22:00'), 
      is_closed: false
    )
    establishment.operating_hours = operating_hour
    establishment.save
    user.establishment = establishment 
    # Act
    login_as user
    visit root_path
    click_on 'Editar informações'
    fill_in 'Endereço',	with: ''
    fill_in 'Telefone',	with: ''
    click_on 'Salvar'
    # Assert
    expect(page).to have_content 'Não foi possível atualizar o estabelecimento'  
  end

  it 'com sucesso' do
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
    operating_hour <<  OperatingHour.new(
      week_day: 6, 
      start_time: Time.zone.parse('08:00'), 
      end_time: Time.zone.parse('22:00'), 
      is_closed: false
    )
    establishment.operating_hours = operating_hour
    establishment.save
    user.establishment = establishment 
    # Act
    login_as user
    visit root_path
    click_on 'Editar informações'
    fill_in 'Endereço',	with: 'Rua nova das novidades'
    fill_in 'Telefone',	with: '85992594946'
    click_on 'Salvar'
    # Assert
    expect(page).to have_content 'Estabelecimento atualizado com sucesso'
    expect(page).to have_content "Código: #{establishment.code}"
    expect(page).to have_content 'Telefone: (85) 99259-4946'
    expect(page).to have_content 'Endereço: Rua nova das novidades' 
  end
end