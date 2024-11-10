require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it 'Não deve ser possível vincular o mesmo prato duas vezes a um mesmo cardápio' do 
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
    )

    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')

    dish = Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )

    MenuItem.create!(item: dish, menu: menu)
    menu_item = MenuItem.new(item: dish, menu: menu)

    # Act
    result = menu_item.valid?

    # Assert
    expect(result).to eq false
  end

  it 'Não deve ser possível vincular a mesma bebida duas vezes a um mesmo cardápio' do 
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
    )

    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')

    beverage = Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )

    MenuItem.create!(item: beverage, menu: menu)
    menu_item = MenuItem.new(item: beverage, menu: menu)

    # Act
    result = menu_item.valid?

    # Assert
    expect(result).to eq false
  end

  it 'É possível vincular um prato a dois cardápios diferentes' do 
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
    )

    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
    menu_two = Menu.create!(establishment: establishment, name: 'Almoço')

    dish = Dish.create!(
      name: 'lasagna', 
      description: 'massa, queijo e presunto', 
      calories: '185', 
      establishment: establishment
    )

    MenuItem.create!(item: dish, menu: menu)
    menu_item = MenuItem.new(item: dish, menu: menu_two)

    # Act
    result = menu_item.valid?

    # Assert
    expect(result).to eq true
  end

  it 'É possível vincular ums bebida a dois cardápios diferentes' do 
    # Arrange
    establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
    )
    User.create!(
      first_name: 'Samuel', 
      last_name: 'Rocha', 
      email: 'samuel@hotmail.com', 
      password: '12345678910111',  
      cpf: '22611819572',
      establishment: establishment
    )

    menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
    menu_two = Menu.create!(establishment: establishment, name: 'Almoço')

    beverage = Beverage.create!(
      name: 'Cachaça', 
      description: 'alcool delicioso baiano', 
      calories: '185', 
      establishment: establishment, 
      is_alcoholic: true
    )

    MenuItem.create!(item: beverage, menu: menu)
    menu_item = MenuItem.new(item: beverage, menu: menu_two)

    # Act
    result = menu_item.valid?

    # Assert
    expect(result).to eq true
  end

end
