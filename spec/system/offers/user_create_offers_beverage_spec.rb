require 'rails_helper'

describe 'Usuário acessa formulário de criar oferta de uma bebida' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    beverage = create(:beverage, establishment: establishment)

    # Act
    visit offer_beverage_path(beverage.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    beverage = create(:beverage, establishment: establishment)

    # Act
    login_as user
    visit offer_beverage_path(beverage.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e vê os campos corretamente' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:beverage, name: 'Cachaça', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    click_on 'Cadastrar volume'

    # Assert
    expect(page).to have_content 'Cadastro de volume de Cachaça'
    expect(page).to have_field 'Nome do volume'
    expect(page).to have_field 'Detalhes do volume'
    expect(page).to have_field 'Preço do volume'
    expect(page).to have_button 'Salvar'
  end

  it 'falha por ausência de campo obrigatório' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:beverage, name: 'Cachaça', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    click_on 'Cadastrar volume'
    fill_in 'Detalhes do volume',	with: 'bombinha de um só'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome da porção não pode ficar em branco'
  end

  it 'com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:beverage, name: 'Cachaça', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    click_on 'Cadastrar volume'
    fill_in 'Detalhes do volume',	with: 'bombinha de um só'
    fill_in 'Nome do volume',	with: 'Bombinha 50ml'
    fill_in 'Preço',	with: '50'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Volume cadastrado com sucesso'
    expect(page).to have_content 'Volumes Disponíveis'
    expect(page).to have_content 'Volume Bombinha 50ml: R$ 50,00'
    expect(page).to have_link 'Editar Preço'
    expect(page).to have_button 'Retirar Oferta'
  end

  it 'consegue vincular mais de um tipo de volume a uma bebida' do
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
    click_on 'Cadastrar volume'
    fill_in 'Detalhes do volume',	with: 'bombinha de um só'
    fill_in 'Nome do volume',	with: 'Bombinha 1l'
    fill_in 'Preço',	with: '500'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Volume cadastrado com sucesso'
    expect(page).to have_content 'Volume Bombinha 1l: R$ 500,00'
  end

  it 'falha ao tentar cadastrar volume de mesmo nome de outro ja existente para um mesmo prato' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    Offer.create!(format: format, item: beverage, price: 25)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'
    click_on 'Cadastrar volume'
    fill_in 'Detalhes do volume',	with: 'bombinha de um só'
    fill_in 'Nome do volume',	with: 'Bombinha 50ml'
    fill_in 'Preço',	with: '500'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Não é possível cadastrar volumes idênticos para a mesma bebida'
  end

  it 'consegue cadastrar mesmo nome de volume pra uma bebida diferente' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    beverage = create(:beverage, name: 'Cachaça', establishment: establishment)
    format = create(:format, name: 'Bombinha 50ml')
    create(:beverage, name: 'água', establishment: establishment)
    Offer.create!(format: format, item: beverage, price: 25)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'água'
    click_on 'Cadastrar volume'
    fill_in 'Detalhes do volume',	with: 'bombinha de um só'
    fill_in 'Nome do volume',	with: 'Bombinha 50ml'
    fill_in 'Preço',	with: '500'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Volume cadastrado com sucesso'
    expect(page).to have_content 'Volume Bombinha 50ml: R$ 500,00'
  end
end
