require 'rails_helper'

describe 'Usuário edita um prato' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    dish = create(:dish, establishment: establishment)

    # Act
    visit edit_establishment_dish_path(establishment.id, dish.id)

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)
    dish = create(:dish, establishment: establishment)

    # Act
    login_as user
    visit edit_establishment_dish_path(establishment.id, dish.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e vê página de detalhes com botão de editar e de atualizar status' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:dish, name: 'lasagna', description: 'massa, queijo e presunto', calories: '185',
                  establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'

    # Assert
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: massa, queijo e presunto'
    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_button 'Desativar Prato'
  end

  it 'e desativa um prato' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:dish, name: 'lasagna', description: 'massa, queijo e presunto', calories: '185',
                  establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Desativar Prato'

    # Assert
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: massa, queijo e presunto'
    expect(page).to have_content 'Status: Inativo'
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_button 'Ativar Prato'
  end

  it 'e ativa um prato' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:dish, name: 'lasagna', calories: '185', description: 'massa, queijo e presunto', status: false,
                  establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Ativar Prato'

    # Assert
    expect(page).to have_content 'Nome: lasagna'
    expect(page).to have_content 'Descrição: massa, queijo e presunto'
    expect(page).to have_content 'Status: Ativo'
    expect(page).to have_content 'Quantidade de calorias: 185'
    expect(page).to have_link 'Cadastrar porção'
    expect(page).to have_button 'Desativar Prato'
  end

  it 'com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:dish, name: 'lasagna', calories: '185', description: 'massa, queijo e presunto',
                  establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'lasagna'
    click_on 'Editar prato'
    fill_in 'Nome',	with: 'Pão com ovo'
    fill_in 'Descrição',	with: 'ovo de galinha 10 reais'
    fill_in 'Quantidade de calorias',	with: '105'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Prato atualizado com sucesso'
    expect(page).to have_content 'Nome: Pão com ovo'
    expect(page).to have_content 'Descrição: ovo de galinha 10 reais'
    expect(page).not_to have_content 'lasagna'
    expect(page).not_to have_content 'massa, queijo e presunto'
  end

  it 'Caso seja o responsável' do
    # Arrange
    establishment = create(:establishment)
    create(:user, establishment: establishment)
    create(:dish, name: 'lasagna', calories: '185', description: 'massa, queijo e presunto',
                  establishment: establishment)
    establishment_two = create(:establishment)
    user_two = create(:user, establishment: establishment_two)
    dish = create(:dish, establishment: establishment)

    # Act
    login_as user_two
    visit establishment_dish_path(establishment.id, dish.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a esse prato'
  end
end
