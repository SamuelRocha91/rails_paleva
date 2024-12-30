require 'rails_helper'

describe 'Usuário acessa página de detalhes de item' do
  it 'e consegue ver histórico de ofertas de um prato' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    format = create(:format, name: 'Porção Giga gante')
    format_two = create(:format, name: 'Porção média')
    format_three = create(:format, name: 'Porção pequena')
    Offer.create!(format: format, item: dish, price: 30, active: false, end_offer: '2064-12-31 15:45:22')
    Offer.create!(format: format_two, item: dish, price: 25, active: false, end_offer: '2064-12-31 15:45:22')
    Offer.create!(format: format_three, item: dish, price: 25, active: true)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'

    # Assert
    expect(page).to have_content 'Histórico'
    within('table') do
      expect(page).to have_content 'Nome da porção'
      expect(page).to have_content 'Data de início'
      expect(page).to have_content 'Data de término'
      expect(page).to have_content 'Preço'
      expect(page).to have_content 'Porção Giga gante'
      expect(page).to have_content 'Porção média'
      expect(page).to have_content 'R$ 25,00'
      expect(page).to have_content 'R$ 30,00'
      expect(page).not_to have_content 'Porção pequena'
    end
  end

  it 'e consegue ver histórico de ofertas de uma bebida' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    format_two = create(:format, name: 'Bombinha 1l')
    Offer.create!(format: format, item: beverage, price: 25, active: true)
    Offer.create!(format: format_two, item: beverage, price: 33, active: false)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'

    # Assert
    expect(page).to have_content 'Histórico'
    within('table') do
      expect(page).to have_content 'Nome do volume'
      expect(page).to have_content 'Data de início'
      expect(page).to have_content 'Data de término'
      expect(page).to have_content 'Preço'
      expect(page).not_to have_content 'Bombinha 50ml'
      expect(page).to have_content 'Bombinha 1l'
      expect(page).to have_content 'R$ 33,00'
      expect(page).not_to have_content 'R$ 25,00'
    end
  end
end
