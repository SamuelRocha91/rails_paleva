require 'rails_helper'

describe 'Usuário acessa formulário de criar oferta de um prato' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)

    # Act
    visit offer_dish_path(dish.id)

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
    visit offer_dish_path(dish.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e vê os campos corretamente' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:dish, name: 'lasagna', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Cadastrar porção'

    # Assert
    expect(page).to have_content 'Cadastro de porção de lasagna'
    expect(page).to have_field 'Nome da porção'
    expect(page).to have_field 'Detalhes da porção'
    expect(page).to have_field 'Preço da porção'
    expect(page).to have_button 'Salvar'
  end

  it 'falha por ausência de campo obrigatório' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:dish, name: 'lasagna', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Cadastrar porção'
    fill_in 'Detalhes da porção',	with: 'Alimenta 50 pessoas'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome da porção não pode ficar em branco'
  end

  it 'com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:dish, name: 'lasagna', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Cadastrar porção'
    fill_in 'Nome da porção',	with: 'Giga gante'
    fill_in 'Detalhes da porção',	with: 'Alimenta 50 pessoas'
    fill_in 'Preço',	with: '50'

    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Porção cadastrada com sucesso'
    expect(page).to have_content 'Porções Disponíveis'
    expect(page).to have_content 'Porção Giga gante: R$ 50,00'
    expect(page).to have_link 'Editar Preço'
    expect(page).to have_button 'Retirar Oferta'
  end

  it 'consegue vincular mais de um tipo de porção a um prato' do
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
    click_on 'Cadastrar porção'
    fill_in 'Nome da porção',	with: 'media'
    fill_in 'Detalhes da porção',	with: 'Alimenta 30 pessoas'
    fill_in 'Preço',	with: '20'

    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Porção cadastrada com sucesso'
    expect(page).to have_content 'Porção media: R$ 20,00'
  end

  it 'falha ao tentar cadastrar porção de mesmo nome de outra ja existente para um mesmo prato' do
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
    click_on 'Cadastrar porção'
    fill_in 'Nome da porção',	with: 'Porção Giga gante'
    fill_in 'Detalhes da porção',	with: 'Alimenta 30 pessoas'
    fill_in 'Preço',	with: '20'

    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Não é possível cadastrar porções idênticas para o mesmo prato'
  end

  it 'consegue cadastrar mesmo nome de porção pra um prato diferente' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    dish = create(:dish, name: 'lasagna', establishment: establishment)
    format = create(:format, name: 'Porção Giga gante')
    create(:dish, name: 'macarronada', establishment: establishment)
    Offer.create!(format: format, item: dish, price: 25)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'macarronada'
    click_on 'Cadastrar porção'
    fill_in 'Nome da porção',	with: 'Porção Giga gante'
    fill_in 'Detalhes da porção',	with: 'Alimenta 30 pessoas'
    fill_in 'Preço',	with: '20'

    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Porção cadastrada com sucesso'
    expect(page).to have_content 'Porção Giga gante: R$ 20,00'
  end
end
