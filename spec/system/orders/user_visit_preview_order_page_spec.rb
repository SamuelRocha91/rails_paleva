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
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    find('.icon-preview').click

    # Assert
    expect(page).to have_content 'Nenhum item foi adicionado ao pedido ainda.'
  end

  it 'com itens, observa valor total do pedido' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    menu = create(:menu, establishment: establishment, name: 'Café da manhã')
    menu_two = create(:menu, establishment: establishment, name: 'Almoço')
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    dish_two = create(:dish, name: 'feijoada', establishment: establishment)
    format = create(:format, name: 'Porção grande')
    format_two = create(:format, name: 'Porção média')
    Offer.create!(format: format, item: dish, price: 55)
    Offer.create!(format: format_two, item: dish, price: 25)
    Offer.create!(format: format, item: dish_two, price: 33)
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
    expect(page).to have_button 'Remover'
  end

  it 'e remove item com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    menu = create(:menu, establishment: establishment, name: 'Café da manhã')
    menu_two = create(:menu, establishment: establishment, name: 'Almoço')
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    dish_two = create(:dish, name: 'feijoada', establishment: establishment)
    format = create(:format, name: 'Porção grande')
    format_two = create(:format, name: 'Porção média')
    Offer.create!(format: format, item: dish, price: 55)
    Offer.create!(format: format_two, item: dish, price: 25)
    Offer.create!(format: format, item: dish_two, price: 33)
    MenuItem.create!(item: dish, menu: menu)
    MenuItem.create!(item: dish_two, menu: menu_two)

    # Act
    login_as user
    visit root_path
    click_on 'Almoço'
    find('.Porção-grande-feijoada').click
    fill_in 'Observação',	with: 'Sem sal'
    click_on 'Adicionar ao Pedido'
    click_on 'Remover'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Item removido do carrinho com sucesso'
  end
end
