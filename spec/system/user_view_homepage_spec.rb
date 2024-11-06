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

  it 'com estabelecimento criado e sem cardápio cadastrado' do
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
    6.times { |i| operating_hour << OperatingHour
                                      .new(week_day: i, is_closed: true)}
    operating_hour <<  OperatingHour.new(
      week_day: 6, 
      start_time: Time.zone.parse('08:00'), 
      end_time: Time.zone.parse('22:00'), 
      is_closed: false
    )
    
    establishment.operating_hours = operating_hour
    establishment.user = user
    establishment.save!
    # Act
    login_as user
    visit root_path
    # Assert
    within('header') do
      expect(page).to have_link 'Pratos'
      expect(page).to have_link 'Bebidas'
      expect(page).to have_link 'Cardápio'
      expect(page).to have_link "#{establishment.trade_name}"
      expect(page).to have_content 'Samuel Rocha - samuel@hotmail.com'  
    end
    expect(page).to have_content 'Cardápios'  
    expect(page).to have_content 'Não existem ainda cardápios cadastrados'
    expect(page).to have_link 'Cadastrar cardápio'
  end

  it 'com estabelecimento criado e cardápios cadastrados' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )

    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
      user: user
    )
    
    dish = Dish.create!(
      name: 'Lasagna', 
      description: 'queijo, presunto e molho', 
      calories: '185', 
      establishment: establishment
    )

    dish_two = Dish.create!(
      name: 'Macarrão', 
      description: 'ao dente', 
      calories: '15', 
      establishment: establishment
    )

    beverage = Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )

    menu = Menu.create!(name: 'Café da manhã', establishment: establishment)
    MenuItem.create!(menu: menu, item: beverage)
    MenuItem.create!(menu: menu, item: dish)
    MenuItem.create!(menu: menu, item: dish_two)

    # Act
    login_as user
    visit root_path
    # Assert
    expect(page).to have_content 'Cardápios'  
    expect(page).not_to have_content 'Não existem ainda cardápios cadastrados'
    expect(page).to have_content 'Café da manhã'
    expect(page).to have_content 'Cachaça'
    expect(page).to have_content 'Macarrão'
    expect(page).to have_content 'Lasagna'
  end
end
