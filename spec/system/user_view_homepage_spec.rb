require 'rails_helper'

describe "Usuário acessa a aplicação" do
  it 'não logado é direcionado para a página de login' do
    # Act
    visit root_path
    # Assert
    expect(current_path).to eq new_user_session_path 
  end

  it 'sem estabelecimento cadastrado é direcionado para cadastrar' do
    # Arrange
    User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )
    # Act
    visit root_path
    fill_in "E-mail",	with: "samuel@hotmail.com" 
    fill_in "Senha",	with: "12345678910111"
    click_on 'Entrar'
    # Assert
    expect(current_path).to eq new_establishment_path
  end

  it 'sem estabelecimento não consegue acessar outra rota' do
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
    expect(page).to have_content 'Você precisa criar um estabelecimento antes de continuar.' 
  end

  it 'com estabelecimento criado, acessa página inicial' do
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
    establishment.user = user
    establishment.save!
    # Act
    login_as user
    visit root_path
    # Assert
    within('header') do
      expect(page).to have_link 'Meus Pratos'
      expect(page).to have_link 'Bebidas'
      expect(page).to have_content 'Samuel Rocha - samuel@hotmail.com'  
    end
    expect(page).to have_content 'Nome Social: Samsumg'
    expect(page).to have_content "Código: #{establishment.code}"
    expect(page).to have_content 'CNPJ: 56924048000140'
    expect(page).to have_content 'Telefone: 71992594946'
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
