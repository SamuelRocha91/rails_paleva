require 'rails_helper'

describe 'Usuário muda status do pedido' do
  it 'e deve estar autenticado' do
    # ACT
    visit orders_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'de aguardando confirmação da cozinha PARA em preparo' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    customer = create(:customer)
    customer_two = create(:customer)
    dish = create(:dish, establishment: establishment)
    format = create(:format)
    menu = create(:menu, establishment: establishment)
    MenuItem.create!(item: dish, menu: menu)
    order = Order.create!(establishment: establishment, customer: customer)
    Order.create!(establishment: establishment, customer: customer_two)
    offer = Offer.create!(format: format, item: dish, price: 55)
    OrderItem.create!(offer: offer, order: order)

    # Act
    login_as user
    visit root_path
    click_on 'Pedidos'
    click_on order.code
    click_on 'Marcar como EM PREPARO'

    # Assert
    expect(page).to have_content 'Status do Pedido atualizado com sucesso'
    within('table') do
      expect(page).to have_content 'Em preparação'
    end
  end

  it 'de em preparo PARA pronto para entrega' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    customer = create(:customer)
    customer_two = create(:customer)
    dish = create(:dish, establishment: establishment)
    format = create(:format)
    menu = create(:menu, establishment: establishment)
    MenuItem.create!(item: dish, menu: menu)
    order = Order.create!(establishment: establishment, customer: customer, status: 2)
    Order.create!(establishment: establishment, customer: customer_two)
    offer = Offer.create!(format: format, item: dish, price: 55)
    OrderItem.create!(offer: offer, order: order)

    # Act
    login_as user
    visit root_path
    click_on 'Pedidos'
    click_on order.code
    click_on 'Marcar como PRONTO PARA ENTREGA'

    # Assert
    expect(page).to have_content 'Status do Pedido atualizado com sucesso'
    within('table') do
      expect(page).to have_content 'Pronto para entrega'
    end
  end

  it 'de pronto para entrega PARA entregue' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    customer = create(:customer)
    customer_two = create(:customer)
    dish = create(:dish, establishment: establishment)
    format = create(:format)
    menu = create(:menu, establishment: establishment)
    MenuItem.create!(item: dish, menu: menu)
    order = Order.create!(establishment: establishment, customer: customer, status: 5)
    Order.create!(establishment: establishment, customer: customer_two)
    offer = Offer.create!(format: format, item: dish, price: 55)
    OrderItem.create!(offer: offer, order: order)

    # Act
    login_as user
    visit root_path
    click_on 'Pedidos'
    click_on order.code
    click_on 'Marcar como ENTREGUE'

    # Assert
    expect(page).to have_content 'Status do Pedido atualizado com sucesso'
    within('table') do
      expect(page).to have_content 'Entregue'
    end
  end

  it 'de pronto para entrega PARA Cancelado' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    customer = create(:customer)
    customer_two = create(:customer)
    dish = create(:dish, establishment: establishment)
    format = create(:format)
    menu = create(:menu, establishment: establishment)
    MenuItem.create!(item: dish, menu: menu)
    order = Order.create!(establishment: establishment, customer: customer, status: 5)
    Order.create!(establishment: establishment, customer: customer_two)
    offer = Offer.create!(format: format, item: dish, price: 55)
    OrderItem.create!(offer: offer, order: order)

    # Act
    login_as user
    visit root_path
    click_on 'Pedidos'
    click_on order.code
    click_on 'Marcar como Cancelado'

    # Assert
    expect(page).to have_content 'Status do Pedido atualizado com sucesso'
    within('table') do
      expect(page).to have_content 'Cancelado'
    end
  end
end
