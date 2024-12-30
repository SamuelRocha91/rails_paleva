require 'rails_helper'

describe 'Usuário acessa formulário de edição de oferta de bebida' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    offer = Offer.create!(format: format, item: beverage, price: 25)

    # Act
    visit edit_offer_beverage_path(beverage.id, offer.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    offer = Offer.create!(format: format, item: beverage, price: 25)

    # Act
    login_as user
    visit edit_offer_beverage_path(beverage.id, offer.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e falha por ausência de campo obrigatório' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    Offer.create!(format: format, item: beverage, price: 25)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    click_on 'Editar Preço'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Preço não pode ficar em branco e deve ser maior que R$ 1,00'
  end

  it 'e atualiza preço com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    Offer.create!(format: format, item: beverage, price: 25)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    click_on 'Editar Preço'
    fill_in 'Preço', with: '50'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Volume atualizado com sucesso'
    expect(page).to have_content 'Volume Bombinha 50ml: R$ 50,00'
  end
end
