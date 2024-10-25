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

  it 'e vê os campos corretamente' do
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
    click_on 'Cadastrar novo prato'
    # Assert
    expect(current_path).to eq new_establishment_dish_path establishment.id
    expect(page).to have_content 'Cadastro de novo prato'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição' 
    expect(page).to have_field 'Quantidade de calorias' 
    expect(page).to have_field 'Imagem do prato'
    expect(page).to have_button 'Salvar'
  end

  it 'falha no cadastro por falta de campo obrigatório' do
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
    click_on 'Cadastrar novo prato'
    fill_in 'Nome',	with: 'Lasagna'
    fill_in 'Quantidade de calorias',	with: '185'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Descrição não pode ficar em branco'
  end

  it 'falha no cadastro por falta de campo obrigatório' do
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
    click_on 'Cadastrar novo prato'
    fill_in 'Nome',	with: 'Lasagna'
    fill_in 'Descrição',	with: 'pao com ovo'
    fill_in 'Quantidade de calorias',	with: '185'
    attach_file 'Imagem', Rails.root.join('spec', 'support', 'pao.jpg')
    click_on 'Salvar'

    # Assert
    expect(current_path).to eq establishment_dishes_path(establishment.id)
    expect(page).to have_content 'Prato cadastrado com sucesso'
    expect(page).to have_content 'Nome: Lasagna'
    expect(page).to have_content 'Descrição: pao com ovo'
    expect(page).to have_link 'Ver detalhes'  
  end
end
