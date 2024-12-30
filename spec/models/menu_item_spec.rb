require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it 'Não deve ser possível vincular o mesmo prato duas vezes a um mesmo cardápio' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    MenuItem.create!(item: dish, menu: menu)
    menu_item = MenuItem.new(item: dish, menu: menu)

    # Act
    result = menu_item.valid?

    # Assert
    expect(result).to eq false
  end

  it 'Não deve ser possível vincular a mesma bebida duas vezes a um mesmo cardápio' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    MenuItem.create!(item: beverage, menu: menu)
    menu_item = MenuItem.new(item: beverage, menu: menu)

    # Act
    result = menu_item.valid?

    # Assert
    expect(result).to eq false
  end

  it 'É possível vincular um prato a dois cardápios diferentes' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
    menu_two = Menu.create!(establishment: establishment, name: 'Almoço')
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    MenuItem.create!(item: dish, menu: menu)
    menu_item = MenuItem.new(item: dish, menu: menu_two)

    # Act
    result = menu_item.valid?

    # Assert
    expect(result).to eq true
  end

  it 'É possível vincular ums bebida a dois cardápios diferentes' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
    menu_two = Menu.create!(establishment: establishment, name: 'Almoço')
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    MenuItem.create!(item: beverage, menu: menu)
    menu_item = MenuItem.new(item: beverage, menu: menu_two)

    # Act
    result = menu_item.valid?

    # Assert
    expect(result).to eq true
  end
end
