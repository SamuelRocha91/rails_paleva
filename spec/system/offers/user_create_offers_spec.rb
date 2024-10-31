require 'rails_helper'

describe 'Usuário acessa formulário de criar oferta' do
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
    dish = Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )

    # Act
    visit offer_dish_path(dish.id)

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
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
      user: user
    )
    Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )

    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'
    click_on 'Cadastrar porção'

    # Assert
    expect(page).to have_content 'Cadastro de porção de lasagna'
    expect(page).to have_field 'Nome da porção'
    expect(page).to have_field 'Detalhes da porção'
    expect(page).to have_field 'Preço da porção'
    expect(page).to have_button 'Salvar'
  end

  it 'falha por ausência de campo obrigatório' do
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
    Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )

    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'
    click_on 'Cadastrar porção'
    fill_in 'Detalhes da porção',	with: 'Alimenta 50 pessoas'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome da porção não pode ficar em branco'
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
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
      user: user
    )
    Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )

    # Act
    login_as user
    visit root_path
    click_on 'Meus Pratos'
    click_on 'lasagna'
    click_on 'Cadastrar porção'
    fill_in 'Nome da porção',	with: 'Giga gante'
    fill_in 'Detalhes da porção',	with: 'Alimenta 50 pessoas'
    fill_in 'Preço',	with: '50'

    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Porção cadastrada com sucesso'
    expect(page).to have_content 'Porções Disponíveis' 
    expect(page).to have_content 'Porção Giga gante: R$ 50,00'
    expect(page).to have_link 'Editar Preço'  
    expect(page).to have_button 'Retirar Oferta'  
  end
end