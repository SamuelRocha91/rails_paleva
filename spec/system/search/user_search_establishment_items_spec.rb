require 'rails_helper'

describe 'Usuário busca por um item' do
  it 'a partir do menu' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as(user)
    visit root_path

    # Assert
    within('header') do
      expect(page).to have_field 'Buscar Item'
      expect(page).to have_select(
        'type',
        with_options: %w[Bebida Comida Ambos]
      )
      expect(page).to have_button 'Pesquisar'
    end
  end

  it 'se sua role não for employee' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)

    # Act
    login_as(user)
    visit root_path

    # Assert
    within('header') do
      expect(page).not_to have_field 'Buscar Item'
      expect(page).not_to have_select(
        'type',
        with_options: %w[Bebida Comida Ambos]
      )
      expect(page).not_to have_button 'Pesquisar'
    end
  end

  it 'e encontra um item de bebida pelo nome' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:beverage, name: 'Chimarrão', description: 'mate com agua', establishment: establishment)
    create(:beverage, name: 'Suco da embasa', description: 'Água que mata a sede', establishment: establishment)

    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Item',	with: 'Chimarrão'
    select 'Bebida', from: 'type'
    click_on 'Pesquisar'

    # Assert
    expect(page).to have_content '1 Resultado encontrado'
    expect(page).to have_content 'Nome: Chimarrão'
    expect(page).to have_content 'Descrição: mate com agua'
  end

  it 'e encontra um item de comida pelo nome' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:dish, name: 'lasagna', description: 'queijo, presunto e molho', establishment: establishment)
    create(:dish, name: 'macarrão', description: 'arroz integral', establishment: establishment)

    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Item',	with: 'lasagna'
    select 'Comida', from: 'type'
    click_on 'Pesquisar'

    # Assert
    expect(page).to have_content '1 Resultado encontrado'
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: queijo, presunto e molho'
  end

  it 'e encontra item de comida e bebida ao mesmo tempo' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:dish, name: 'lasagna', description: 'queijo, presunto e molho', establishment: establishment)
    create(:dish, name: 'macarrão agua', description: 'macarrão com agua e sal', establishment: establishment)
    create(:beverage, name: 'Chimarrão', description: 'mate com agua', establishment: establishment)
    create(:beverage, name: 'Suco da embasa', description: 'tonico que mata a sede', establishment: establishment)

    # Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Item',	with: 'agua'
    select 'Ambos', from: 'type'
    click_on 'Pesquisar'

    # Assert
    expect(page).to have_content '2 Resultados encontrados'
    expect(page).to have_content 'Nome: Chimarrão'
    expect(page).to have_content 'Descrição: mate com agua'
    expect(page).to have_content 'Nome: macarrão'
    expect(page).to have_content 'Descrição: macarrão com agua e sal'
    expect(page).to have_link 'Editar prato'
    expect(page).to have_link 'Editar bebida'
  end
end
