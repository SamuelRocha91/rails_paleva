require 'rails_helper'

describe 'Usuário acessa página para desativar oferta de um prato' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)

    # Act
    visit establishment_dish_path(establishment.id, dish.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)

    # Act
    login_as user
    visit establishment_dish_path(establishment.id, dish.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e desativa com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    format = create(:format, name: 'Porção Giga gante')
    format_two = create(:format, name: 'Porção pequena')
    Offer.create!(format: format, item: dish, price: 25)
    Offer.create!(format: format_two, item: dish, price: 33)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    find('button.Porção-Giga-gante').click

    # Assert
    expect(page).not_to have_content 'Porção Giga gante: R$ 25,00'
    expect(page).to have_content 'Porção pequena: R$ 33,00'
  end
end
