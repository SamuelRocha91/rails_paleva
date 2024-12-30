require 'rails_helper'

describe 'Usuário vê seus próprios pratos' do
  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    create(:dish, establishment: establishment)

    # Act
    login_as user
    visit establishment_dishes_path(establishment.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e navega para a página de detalhes' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    dish = create(:dish, name: 'lasagna', description: 'pao com ovo', calories: '185', establishment: establishment)
    dish.image.attach(
      io: File.open(Rails.root.join('spec/support/pao.jpg')),
      filename: 'pao.jpg'
    )

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'

    # Assert
    expect(current_path).to eq establishment_dish_path(establishment.id, dish.id)

    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: pao com ovo'
    expect(page).to have_css('img[src*="pao.jpg"]')
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_link 'Editar prato'
  end

  it 'e não vê em sua página pratos de outros usuários' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    establishment_two = create(:establishment)
    create(:user, establishment: establishment_two)
    create(:dish, name: 'lasagna', description: 'pao com ovo', calories: '185', establishment: establishment)
    create(:dish, name: 'macarrao', description: 'arroz integral', calories: '15', establishment: establishment_two)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'

    # Assert
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: pao com ovo'
    expect(page).not_to have_content 'Quantidade de calorias: 15'
    expect(page).not_to have_content 'Nome: Macarrao'
  end

  it 'e não consegue acessar página de pratos de outros usuários' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    establishment_two = create(:establishment)
    create(:user, establishment: establishment_two)
    create(:dish, establishment: establishment)
    dish_two = create(:dish, establishment: establishment_two)

    # Act
    login_as user
    visit establishment_dish_path(establishment_two.id, dish_two)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a esse prato'
  end
end
