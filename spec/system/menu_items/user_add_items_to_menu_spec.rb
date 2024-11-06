require 'rails_helper'

describe 'Usuário acessa formulário de cadastro de item para um cardápio' do
  it 'e deve estar autenticado' do
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

    menu = Menu.create!(
      establishment: establishment, 
      name: 'Café da manhã'
    )

    # Act
    visit new_menu_menu_item_path menu

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e cadastra prato com sucesso' do
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

    menu = Menu.create!(
      establishment: establishment, 
      name: 'Café da manhã'
    )

    Dish.create!(
      name: 'lasagna', 
      description: 'pão com ovo', 
      calories: '185', 
      establishment: establishment
    )

    Dish.create!(
      name: 'macarrão', 
      description: 'arroz integral', 
      calories: '15', 
      establishment: establishment
    )
    # Act
    login_as user
    visit root_path
    click_on 'Café da manhã'
    click_on 'Adicionar Prato'
    select 'macarrão', from: 'Item'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Item adicionado com sucesso'
    expect(page).to have_content 'Café da manhã'
    expect(page).to have_content 'macarrão'
  end

  it 'e cadastra bebida com sucesso' do
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

    menu = Menu.create!(
      establishment: establishment, 
      name: 'Café da manhã'
    )

    Beverage.create!(
      name: 'Café amargo', 
      description: 'sem açúcar daquele jeitão', 
      calories: '185', 
      establishment: establishment
    )

    Beverage.create!(
      name: 'Coca-Cola', 
      description: 'Açúcar com gás', 
      calories: '15', 
      establishment: establishment
    )

    # Act
    login_as user
    visit root_path
    click_on 'Café da manhã'
    click_on 'Adicionar Bebida'
    select 'Café amargo', from: 'Item'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Café da manhã'
    expect(page).to have_content 'Café amargo'
  end
end