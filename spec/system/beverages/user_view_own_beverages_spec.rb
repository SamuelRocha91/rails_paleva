require 'rails_helper'

describe 'Usuário vê suas próprias bebidas' do
  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    create(:beverage, :alcoholic, name: 'cachaça', description: 'alcool delicioso baiano',
                                  establishment: establishment)

    # Act
    login_as user
    visit establishment_beverages_path(establishment.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e navega para a página de detalhes' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    beverage = create(:beverage, :alcoholic, calories: '185', name: 'Cachaça', description: 'alcool delicioso baiano',
                                             establishment: establishment)
    beverage.image.attach(
      io: File.open(Rails.root.join('spec/support/pao.jpg')),
      filename: 'pao.jpg'
    )
    create(:beverage, :alcoholic, name: 'Suco da embasa', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'Cachaça'

    # Assert
    expect(current_path).to eq establishment_beverage_path(establishment.id, beverage.id)
    expect(page).to have_content 'Nome: Cachaça'
    expect(page).to have_content 'Descrição: alcool delicioso baiano'
    expect(page).to have_css('img[src*="pao.jpg"]')
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_content 'É alcoólica? Sim'
    expect(page).to have_link 'Cadastrar volume'
    expect(page).to have_link 'Editar bebida'
  end

  it 'e não vê bebidas de outros estabelecimentos' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    establishment_two = create(:establishment, email: 'bill@gmail.com', trade_name: 'Microsoft')
    create(:user, establishment: establishment_two)

    beverage = create(:beverage, name: 'Cachaça', description: 'alcool delicioso baiano', calories: '185',
                                 establishment: establishment)
    beverage.image.attach(
      io: File.open(Rails.root.join('spec/support/pao.jpg')),
      filename: 'pao.jpg'
    )

    create(:beverage, name: 'Chimarrão', description: 'mate com agua', calories: '15', establishment: establishment)

    create(:beverage, name: 'Suco da embasa', description: 'Água que mata a sede', calories: '1',
                      establishment: establishment_two)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'

    # Assert
    expect(page).to have_content 'Nome: Cachaça'
    expect(page).to have_content 'Descrição: alcool delicioso baiano'
    expect(page).not_to have_content 'Nome: Suco da embasa'
    expect(page).not_to have_content 'Descrição: Água que mata a sede'
  end

  it 'e não página de deetalhes de bebidas de outros estabelecimentos' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    establishment_two = create(:establishment, email: 'bill@gmail.com', trade_name: 'Microsoft')

    create(:user, establishment: establishment_two)
    beverage = create(:beverage, name: 'Cachaça', description: 'alcool delicioso baiano', calories: '185',
                                 establishment: establishment)
    beverage.image.attach(
      io: File.open(Rails.root.join('spec/support/pao.jpg')),
      filename: 'pao.jpg'
    )
    create(:beverage, name: 'Chimarrão', description: 'mate com agua', establishment: establishment)
    beverage_two = create(:beverage, name: 'Suco da embasa', description: 'Água que mata a sede',
                                     establishment: establishment_two)

    # Act
    login_as user
    visit establishment_beverage_path(establishment_two, beverage_two)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a essa bebida'
  end
end
