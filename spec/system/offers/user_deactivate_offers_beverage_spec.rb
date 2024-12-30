require 'rails_helper'

describe 'Usuário acessa página para desativar oferta de uma bebida' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    Offer.create!(format: format, item: beverage, price: 25)

    # Act
    visit establishment_beverage_path(establishment.id, beverage.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    Offer.create!(format: format, item: beverage, price: 25)

    # Act
    login_as user
    visit establishment_beverage_path(establishment.id, beverage.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e desativa com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    Offer.create!(format: format, item: beverage, price: 50)
    format_two = create(:format, name: 'Bombinha 1l')
    Offer.create!(format: format_two, item: beverage, price: 33)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    find('button.Bombinha-50ml').click

    # Assert
    expect(page).not_to have_content 'Volume Bombinha 50ml: R$ 50,00'
    expect(page).to have_content 'Volume Bombinha 1l: R$ 33,00'
  end
end
