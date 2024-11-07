require 'rails_helper'

describe 'Usuário acessa formulário de cadastro de estabelecimento' do
  it 'e deve estar autenticado' do
    # Act
    visit new_establishment_path
    # Assert
    expect(current_path).to eq new_user_session_path  
  end

  it 'e encontra todos dados de cadastro' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    # Act
    login_as user
    visit root_path
    # Assert
    expect(current_path).to eq new_establishment_path  
    expect(page).to have_content 'Cadastrar Restaurante'
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

  it 'tem cadastro recusado por falta de campo obrigatório' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    # Act
    login_as user
    visit root_path
  
    fill_in 'Nome Social',	with: 'Comidícia'
    fill_in 'CNPJ',	with: '56924048000140'
    fill_in 'Endereço',	with: 'Rua da Fome, 100'
    click_on 'Salvar'
    # Assert
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
  end

  it 'deve cadastrar todos os dias da semana' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    # Act
    login_as user
    visit root_path
  
    fill_in 'Nome Social',	with: 'Comidícia'
    fill_in 'CNPJ',	with: '56924048000140'
    fill_in 'Endereço',	with: 'Rua da Fome, 100'
    fill_in 'Nome Fantasia',	with: 'Engordante LTDA'
    fill_in 'Telefone',	with: '71992594946'
    fill_in 'E-mail',	with: 'sam@gmail.com'
  
    find('input[type="checkbox"].saturday').set(true)
    find('input[type="checkbox"].monday').set(true)
    find('input[type="checkbox"].tuesday').set(true)
    find('input[type="checkbox"].wednesday').set(true)

    click_on 'Salvar'
    # Assert
    expect(page).not_to have_content 'Horário de funcionamento de Sábado deve ser definido ou marcado como fechado.'
    expect(page).to have_content 'Horário de funcionamento de Quinta deve ser definido ou marcado como fechado.'
    expect(page).to have_content 'Horário de funcionamento de Sexta deve ser definido ou marcado como fechado.'
    expect(page).to have_content 'Horário de funcionamento de Domingo deve ser definido ou marcado como fechado.'
  end

  it 'tenta cadastrar horario de fechamento menor que o de abertura' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    # Act
    login_as user
    visit root_path
  
    fill_in 'Nome Social',	with: 'Comidícia'
    fill_in 'CNPJ',	with: '56924048000140'
    fill_in 'Endereço',	with: 'Rua da Fome, 100'
    fill_in 'Nome Fantasia',	with: 'Engordante LTDA'
    fill_in 'Telefone',	with: '71992594946'
    fill_in 'E-mail',	with: 'sam@gmail.com'
  
    find('input[type="checkbox"].sunday').set(true)
    find('input[type="checkbox"].monday').set(true)
    find('input[type="checkbox"].tuesday').set(true)
    find('input[type="checkbox"].wednesday').set(true)
  
    all('input[type="time"].thursday')[1].set('08:00')
    all('input[type="time"].thursday')[0].set('22:00')
    all('input[type="time"].friday')[0].set('08:00')
    all('input[type="time"].friday')[1].set('22:00')
    all('input[type="time"].saturday')[0].set('08:00')
    all('input[type="time"].saturday')[1].set('22:00')
  
    click_on 'Salvar'
    # Assert
    expect(page).to have_content 'Horário de funcionamento de Quinta deve ser definido ' +
           'corretamente(Hora de abertura deve ser menor que a de fechamento).'

  end

  it 'cadastra restaurante e é direcionado pra página root' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    # Act
    login_as user
    visit root_path
  
    fill_in 'Nome Social',	with: 'Comidícia'
    fill_in 'CNPJ',	with: '56924048000140'
    fill_in 'Endereço',	with: 'Rua da Fome, 100'
    fill_in 'Nome Fantasia',	with: 'Engordante LTDA'
    fill_in 'Telefone',	with: '71992594946'
    fill_in 'E-mail',	with: 'sam@gmail.com'

    find('input[type="checkbox"].sunday').set(true)
    find('input[type="checkbox"].monday').set(true)
    find('input[type="checkbox"].tuesday').set(true)
    find('input[type="checkbox"].wednesday').set(true)
  
    all('input[type="time"].thursday')[0].set('08:00')
    all('input[type="time"].thursday')[1].set('22:00')
    all('input[type="time"].friday')[0].set('08:00')
    all('input[type="time"].friday')[1].set('22:00')
    all('input[type="time"].saturday')[0].set('08:00')
    all('input[type="time"].saturday')[1].set('22:00')
  
    click_on 'Salvar'
    # Assert
    expect(current_path).to eq establishments_path
    expect(page).to have_content 'Cadastro de restaurante efetuado com sucesso!'
  end


  it 'ja tendo um cadastrado e é redirecionado' do
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
    7.times { |i| operating_hour << OperatingHour
                                      .new(week_day: i, is_closed: true)}
    establishment.operating_hours = operating_hour
    establishment.save
    user.establishment = establishment 

    # Act
    login_as user
    visit new_establishment_path
    # Assert
    expect(current_path).to eq root_path  
  end
end