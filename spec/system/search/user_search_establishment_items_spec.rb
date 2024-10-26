require 'rails_helper'

describe 'Usuário busca por um item' do
  it 'a partir do menu' do
    # Arrange 
     user = User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572'
    )

    Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
      user: user
    )
    # Act
    login_as(user)
    visit root_path
    # Assert
    within('header') do
      expect(page).to have_field 'Buscar Item'
      expect(page).to have_select('type', with_options: ['Bebida', 'Comida', 'Ambos'])
      expect(page).to have_button 'Pesquisar'  
    end
  end

  it 'e encontra um item de bebida pelo nome' do
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

    Beverage.create!(name: 'Chimarrão', description: 'mate com agua', 
                      calories: '15', establishment: establishment, is_alcoholic: true)

    Beverage.create!(name: 'Suco da embasa', description: 'Água que mata a sede', 
                      calories: '1', establishment: establishment, is_alcoholic: false)
    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Item',	with: "Chimarrão"
    select 'Bebida', from: 'type'
    click_on 'Pesquisar'
    
    # Assert
    expect(page).to have_content '1 Resultado encontrado'
    expect(page).to have_content 'Nome: Chimarrão'
    expect(page).to have_content 'Descrição: mate com agua'
  end

  it 'e encontra um item de comida pelo nome' do
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

    Dish.create!(name: 'lasagna', description: 'queijo, presunto e molho', 
                 calories: '185', establishment: establishment)
    Dish.create!(name: 'macarrão', description: 'arroz integral', 
                 calories: '15', establishment: establishment)
    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Item',	with: "lasagna"
    select 'Comida', from: 'type'
    click_on 'Pesquisar'
    
    # Assert
    expect(page).to have_content '1 Resultado encontrado'
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: queijo, presunto e molho'
  end

  it 'e encontra item de comida e bebida ao mesmo tempo' do
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

    Dish.create!(name: 'lasagna', description: 'queijo, presunto e molho', 
                 calories: '185', establishment: establishment)
    Dish.create!(name: 'macarrão', description: 'arroz integral com agua', 
                 calories: '15', establishment: establishment)
    
    Beverage.create!(name: 'Chimarrão', description: 'mate com agua', 
                      calories: '15', establishment: establishment, is_alcoholic: true)

    Beverage.create!(name: 'Suco da embasa', description: 'tonico que mata a sede', 
                      calories: '1', establishment: establishment, is_alcoholic: false)
    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Item',	with: "agua"
    select 'Ambos', from: 'type'
    click_on 'Pesquisar'
    
    # Assert
    expect(page).to have_content '2 Resultados encontrados'
    expect(page).to have_content 'Nome: Chimarrão'
    expect(page).to have_content 'Descrição: mate com agua'
    expect(page).to have_content 'Nome: macarrão'
    expect(page).to have_content 'Descrição: arroz integral com agua'
    expect(page).to have_link 'Editar prato'
    expect(page).to have_link 'Editar bebida'

  end
end