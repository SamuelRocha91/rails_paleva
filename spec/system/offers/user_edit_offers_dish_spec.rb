require 'rails_helper'

describe 'Usuário acessa formulário de edição de oferta prato' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    format = create(:format, name: 'Porção Giga gante')
    offer = Offer.create!(format: format, item: dish, price: 25)

    # Act
    visit edit_offer_dish_path(dish.id, offer.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    format = create(:format, name: 'Porção Giga gante')
    offer = Offer.create!(format: format, item: dish, price: 25)

    # Act
    login_as user
    visit edit_offer_dish_path(dish.id, offer.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e falha por ausência de campo obrigatório' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    format = create(:format, name: 'Porção Giga gante')
    Offer.create!(format: format, item: dish, price: 25)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Editar Preço'
    fill_in 'Preço',	with: ''
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Preço não pode ficar em branco e deve ser maior que R$ 1,00'
  end

  it 'e atualiza preço com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    format = create(:format, name: 'Porção Giga gante')
    Offer.create!(format: format, item: dish, price: 25)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Editar Preço'
    fill_in 'Preço', with: '50'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Porção atualizada com sucesso'
    expect(page).to have_content 'Porção Giga gante: R$ 50,00'
    expect(page).not_to have_content 'Porção Giga gante: R$ 25,00'
  end
end
