require 'rails_helper'

describe 'Usuário edita uma bebida' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    beverage = create(:beverage, establishment: establishment)

    # Act
    visit edit_establishment_beverage_path(establishment.id, beverage.id)

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
    visit edit_establishment_beverage_path(establishment.id, beverage.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e vê página de detalhes com botão de editar e de atualizar status' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:beverage, :alcoholic, name: 'cachaça', description: 'alcool delicioso baiano', calories: '185',
                                  establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'cachaça'

    # Assert
    expect(page).to have_content 'Nome: cachaça'
    expect(page).to have_content 'Descrição: alcool delicioso baiano'
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_content 'É alcoólica? Sim'
    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_button 'Desativar Bebida'
    expect(page).to have_content 'Editar bebida'
  end

  it 'e desativa uma bebida' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:beverage, :alcoholic, name: 'cachaça', description: 'alcool delicioso baiano', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'cachaça'
    click_on 'Desativar Bebida'

    # Assert
    expect(page).to have_content 'Nome: cachaça'
    expect(page).to have_content 'Descrição: alcool delicioso baiano'
    expect(page).to have_content 'Status: Inativo'
    expect(page).to have_button 'Ativar Bebida'
  end

  it 'e ativa uma bebida' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:beverage, :alcoholic, name: 'cachaça', description: 'alcool delicioso baiano', status: false,
                                  establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'cachaça'
    click_on 'Ativar Bebida'

    # Assert
    expect(page).to have_content 'Nome: cachaça'
    expect(page).to have_content 'Descrição: alcool delicioso baiano'
    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_button 'Desativar Bebida'
  end

  it 'com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:beverage, :alcoholic, name: 'cachaça', description: 'alcool delicioso baiano',
                                  establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Bebidas'
    click_on 'cachaça'
    click_on 'Editar bebida'
    fill_in 'Nome',	with: 'Suco da embasa'
    fill_in 'Descrição', with: 'aguinha que mata a sede'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Bebida atualizada com sucesso'
    expect(page).to have_content 'Nome: Suco da embasa'
    expect(page).to have_content 'Descrição: aguinha que mata a sede'
    expect(page).not_to have_content 'cachaça'
    expect(page).not_to have_content 'alcool delicioso baiano'
  end

  it 'Caso seja o responsável' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    beverage = create(:beverage, :alcoholic, name: 'cachaça', description: 'alcool delicioso baiano',
                                             establishment: establishment)
    establishment_two = create(:establishment)

    user_two = create(:user, establishment: establishment_two)

    # Act
    login_as user_two
    visit establishment_dish_path(establishment.id, beverage.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a esse prato'
  end
end
