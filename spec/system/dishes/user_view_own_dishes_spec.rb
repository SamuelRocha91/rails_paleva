require 'rails_helper'

describe 'Usuário vê seus próprios pratos' do

  it 'e navega para a página de detalhes' do
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
    establishment.save
    user.establishment = establishment 
    dish = Dish.new(
      name: 'lasagna', 
      description: 'pao com ovo', 
      calories: '185'
    )
    dish.image.attach(
      io: File.open(Rails.root.join('spec', 'support', 'pao.jpg')), 
      filename: 'pao.jpg'
    )
    dish.establishment = establishment
    dish.save
    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'

    # Assert
    expect(current_path).to eq establishment_dish_path(establishment.id, dish.id)
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: pao com ovo'
    expect(page).to have_css('img[src*="pao.jpg"]')
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_link 'Editar prato'  
  end 

  it 'e não vê em sua página pratos de outros usuários' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )

    user_two = User.create!(
      first_name: 'Bill', 
      last_name: 'Gates', 
      email: 'ng@hotmail.com', 
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
      email:'sam@gmail.com', 
      trade_name: 'Samsumg', 
      legal_name: 'Samsumg LTDA', 
      cnpj: CNPJ.generate,
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas' 
    )
    operating_hour = []
    operating_hour_two = []

    6.times { |i| operating_hour << OperatingHour
                                      .new(week_day: i, is_closed: true)}
    operating_hour <<  OperatingHour.new(
      week_day: 6, 
      start_time: Time.zone.parse('08:00'), 
      end_time: Time.zone.parse('22:00'), 
      is_closed: false
    )

    6.times { |i| operating_hour_two << OperatingHour
                                          .new(week_day: i, is_closed: true)}
    operating_hour <<  OperatingHour.new(
      week_day: 6, 
      start_time: Time.zone.parse('08:00'), 
      end_time: Time.zone.parse('22:00'), 
      is_closed: false
    )

    establishment.operating_hours = operating_hour
    establishment_two.operating_hours = operating_hour
  
    user.establishment = establishment
    user_two.establishment = establishment

    establishment.user = user
    establishment_two.user = user
    establishment.save!
    establishment_two.save!

    dish = Dish.new(
      name: 'lasagna', 
      description: 'pao com ovo', 
      calories: '185'
    )
    dish_two = Dish.new(
      name: 'macarrao', 
      description: 'arroz integral', 
      calories: '15'
    )

    dish.establishment = establishment
    dish_two.establishment = establishment

    dish.save
    dish_two.save
    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'

    # Assert
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: pao com ovo'
    expect(page).not_to have_content 'Quantidade de calorias: 15'
    expect(page).not_to have_content  'Nome: Macarrao' 
  end  

  it 'e não consegue acessar página de pratos de outros usuários' do
    # Arrange
    user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )

    user_two = User.create!(
      first_name: 'Bill', 
      last_name: 'Gates', 
      email: 'ng@hotmail.com', 
      password: '12345678910111',  
      cpf: CPF.generate
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

    establishment_two = Establishment.create!(
      email: 'bill@gmail.com', 
      trade_name: 'Microsoft', 
      legal_name: 'Microsoft LTDA', 
      cnpj: '12345678000195',
      phone_number: '71992594950', 
      address: 'Rua da Microsoft',
      user: user_two
    )

    Dish.create!(
      name: 'lasagna', 
      description: 'pão com ovo', 
      calories: '185', 
      establishment: establishment
    )
    dish_two = Dish.create!(
      name: 'macarrão', 
      description: 'arroz integral', 
      calories: '15', 
      establishment: establishment_two
    )

    # Act
    login_as user
    visit establishment_dish_path(establishment_two, dish_two)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a esse prato'
  end

end

