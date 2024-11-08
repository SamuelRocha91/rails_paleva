require 'rails_helper'

describe 'Usuário acessa página de pré-visualização de pedido' do
  it 'e deve estar autenticado' do
    # Act
    visit preview_order_path

    # Assert
    expect(current_path).to eq new_user_session_path  
  end

  it 'sem itens adicionados' do
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
    login_as user
    visit root_path
    find('.icon-preview').click

    # Assert
    expect(page).to have_content 'Nenhum item foi adicionado ao pedido ainda.'
  end

  it 'com itens, observa valor total do pedido' do
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
    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
    menu_two = Menu.create!(establishment: establishment, name: 'Almoço')

    dish = Dish.create!(
          name: 'lasagna', 
          description: 'massa, queijo e presunto', 
          calories: '185', 
          establishment: establishment
        )
    dish_two = Dish.create!(
          name: 'feijoada', 
          description: 'feijao e condimentos', 
          calories: '185', 
          establishment: establishment
        )

    format = Format.create!(name: 'Porção grande')
    format_two = Format.create!(name: 'Porção média')

    Offer.create!(
      format: format,
      item: dish,
      price: 55
    )
    Offer.create!(
      format: format_two,
      item: dish,
      price: 25
    )

    Offer.create!(
      format: format,
      item: dish_two,
      price: 33
    )

    MenuItem.create!(item: dish, menu: menu)
    MenuItem.create!(item: dish_two, menu: menu_two)


    # Act
    login_as user
    visit root_path
    click_on 'Almoço'
    find('.Porção-grande-feijoada').click
    fill_in 'Observação',	with: 'Sem sal' 
    click_on 'Adicionar ao Pedido'
    click_on 'Continuar adicionando itens'
    click_on 'Café da manhã'
    find('.Porção-grande-lasagna').click
    fill_in 'Observação',	with: 'Sem cebola' 
    click_on 'Adicionar ao Pedido'

    # Assert
    expect(page).to have_content 'Valor Total: R$ 88,00'
  end
end