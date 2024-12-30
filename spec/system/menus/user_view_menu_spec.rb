require 'rails_helper'

describe 'Usuário acessa página de visualização de cardápio' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    menu = create(:menu, establishment: establishment)

    # Act
    visit menu_path menu.id

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e visualiza menu' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    menu = create(:menu, name: 'Café da manhã', establishment: establishment)
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    format = create(:format)
    Offer.create!(format: format, item: beverage, price: 25)
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    format_two = create(:format, name: 'Giga gante')
    format_three = create(:format, name: 'média')
    Offer.create!(format: format_two, item: dish, price: 27)
    Offer.create!(format: format_three, item: dish, price: 12)
    MenuItem.create!(item: dish, menu: menu)
    MenuItem.create!(item: beverage, menu: menu)

    # Act
    login_as user
    visit root_path

    # Assert
    expect(page).to have_link 'Café da manhã'
    expect(page).to have_content 'Prato: lasagna'
    expect(page).to have_content 'Bebida: Cachaça'
  end

  it 'desde que o menu esteja no seu período sazonal' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:menu, name: 'Café da manhã', establishment: establishment)
    menu = create(:menu, name: 'Almoço', valid_from: 1.day.from_now, valid_until: 5.days.from_now)
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    Offer.create(format: format, item: beverage, price: 25)
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    format_two = create(:format, name: 'Giga gante')
    format_three = create(:format, name: 'média')
    Offer.create!(format: format_two, item: dish, price: 27)
    Offer.create!(format: format_three, item: dish, price: 12)
    MenuItem.create!(item: dish, menu: menu)
    MenuItem.create!(item: beverage, menu: menu)

    # Act
    login_as user
    visit root_path

    # Assert
    expect(page).not_to have_link 'Almoço'
  end

  it 'dentro do perído específico, visualiza cardápio sazonal' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:menu, name: 'Café da manhã', establishment: establishment)
    menu = create(:menu, name: 'Almoço', valid_from: 1.day.from_now, valid_until: 5.days.from_now,
                         establishment: establishment)
    beverage = create(:beverage, establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    Offer.create!(format: format, item: beverage, price: 25)
    dish = create(:dish, establishment: establishment)
    format_two = create(:format, name: 'Giga gante')
    format_three = create(:format, name: 'média')
    Offer.create!(format: format_two, item: dish, price: 27)
    Offer.create!(format: format_three, item: dish, price: 12)
    MenuItem.create!(item: dish, menu: menu)
    MenuItem.create!(item: beverage, menu: menu)

    travel_to 1.day.from_now do
      # Act
      login_as user
      visit root_path

      # Assert
      expect(page).to have_link 'Almoço'
    end
  end

  it 'e visualiza pratos com itens e porções na página do cardápio' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    menu = create(:menu, name: 'Café da manhã', establishment: establishment)
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    Offer.create!(format: format, item: beverage, price: 25)
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    format_two = create(:format, name: 'Giga gante')
    format_three = create(:format, name: 'média')
    Offer.create!(format: format_two, item: dish, price: 27)
    Offer.create!(format: format_three, item: dish, price: 12)
    MenuItem.create!(item: dish, menu: menu)
    MenuItem.create!(item: beverage, menu: menu)

    # Act
    login_as user
    visit root_path
    click_on 'Café da manhã'

    # Assert
    expect(page).to have_content 'Cardápio: Café da manhã'
    expect(page).to have_content 'Prato: lasagna'
    expect(page).to have_content 'Bebida: Cachaça'
    expect(page).to have_content 'Volume Bombinha 50ml: R$ 25,00'
    expect(page).to have_content 'Porção Giga gante: R$ 27,00'
    expect(page).to have_content 'Porção média: R$ 12,00'
  end
end
