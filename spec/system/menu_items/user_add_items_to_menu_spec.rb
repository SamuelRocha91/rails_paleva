require 'rails_helper'

describe 'Usuário acessa formulário de cadastro de item para um cardápio' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    menu = create(:menu, establishment: establishment)

    # Act
    visit new_menu_menu_item_path menu

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    menu = create(:menu, establishment: establishment)

    # Act
    login_as user
    visit new_menu_menu_item_path menu

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e cadastra prato com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:menu, name: 'Café da manhã', establishment: establishment)
    create(:dish, name: 'lasagna', establishment: establishment)
    create(:dish, name: 'macarrão', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Café da manhã'
    click_on 'Adicionar Prato'
    select 'macarrão', from: 'Item'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Item adicionado com sucesso'
    expect(page).to have_content 'Café da manhã'
    expect(page).to have_content 'macarrão'
  end

  it 'e cadastra bebida com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:menu, name: 'Café da manhã', establishment: establishment)
    create(:beverage, name: 'Café amargo', establishment: establishment)
    create(:beverage, name: 'Coca-Cola', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Café da manhã'
    click_on 'Adicionar Bebida'
    select 'Café amargo', from: 'Item'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Café da manhã'
    expect(page).to have_content 'Café amargo'
  end

  it 'item já cadastrado não pode ser duplicado no cardápio' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    menu = create(:menu, name: 'Café da manhã', establishment: establishment)
    beverage = create(:beverage, name: 'Café amargo', establishment: establishment)
    create(:beverage, name: 'Coca-Cola', establishment: establishment)
    MenuItem.create!(item: beverage, menu: menu)

    # Act
    login_as user
    visit root_path
    click_on 'Café da manhã'
    click_on 'Adicionar Bebida'

    # Assert
    expect(page).not_to have_content 'Café amargo'
    expect(page).to have_content 'Coca-Cola'
  end
end
