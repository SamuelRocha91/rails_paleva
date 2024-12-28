require 'rails_helper'

describe 'Usuário vê seus próprios pratos' do
  it 'e deve ser :admin' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
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

    Dish.create!(
      name: 'lasagna',
      description: 'pão com ovo',
      calories: '185',
      establishment: establishment
    )

    # Act
    login_as user
    visit establishment_dishes_path(establishment.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e navega para a página de detalhes' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
    )
    user = User.create!(
      first_name: 'Samuel',
      last_name: 'Rocha',
      email: 'samuel@hotmail.com',
      password: '12345678910111',
      cpf: '22611819572',
      establishment: establishment
    )

    dish = Dish.new(
      name: 'lasagna',
      description: 'pao com ovo',
      calories: '185'
    )
    dish.image.attach(
      io: File.open(Rails.root.join('spec/support/pao.jpg')),
      filename: 'pao.jpg'
    )
    dish.establishment = establishment
    dish.save

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
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
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
    )
    user = User.create!(
      first_name: 'Samuel',
      last_name: 'Rocha',
      email: 'samuel@hotmail.com',
      password: '12345678910111',
      cpf: '22611819572',
      establishment: establishment
    )

    establishment_two = Establishment.create!(
      email: 'bill@gmail.com',
      trade_name: 'Microsoft',
      legal_name: 'Microsoft LTDA',
      cnpj: '12345678000195',
      phone_number: '71992594950',
      address: 'Rua da Microsoft'
    )

    User.create!(
      first_name: 'Bill',
      last_name: 'Gates',
      email: 'ng@hotmail.com',
      password: '12345678910111',
      cpf: CPF.generate,
      establishment: establishment_two
    )

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

    dish.save!
    dish_two.save!

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'

    # Assert
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: pao com ovo'
    expect(page).not_to have_content 'Quantidade de calorias: 15'
    expect(page).not_to have_content 'Nome: Macarrao'
  end

  it 'e não consegue acessar página de pratos de outros usuários' do
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com',
      trade_name: 'Samsung',
      legal_name: 'Samsung LTDA',
      cnpj: '56924048000140',
      phone_number: '71992594946',
      address: 'Rua das Alamedas avenidas'
    )
    user = User.create!(
      first_name: 'Samuel',
      last_name: 'Rocha',
      email: 'samuel@hotmail.com',
      password: '12345678910111',
      cpf: '22611819572',
      establishment: establishment
    )

    establishment_two = Establishment.create!(
      email: 'bill@gmail.com',
      trade_name: 'Microsoft',
      legal_name: 'Microsoft LTDA',
      cnpj: '12345678000195',
      phone_number: '71992594950',
      address: 'Rua da Microsoft'
    )

    User.create!(
      first_name: 'Bill',
      last_name: 'Gates',
      email: 'ng@hotmail.com',
      password: '12345678910111',
      cpf: CPF.generate,
      establishment: establishment_two
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
    visit establishment_dish_path(establishment_two.id, dish_two)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a esse prato'
  end
end
