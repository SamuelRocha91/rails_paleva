require 'rails_helper'

describe 'Usuário acessa formulário de cadastro de cardápio' do
  it 'e deve estar autenticado' do
    # Act
    visit new_menu_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)

    # Act
    login_as user
    visit new_menu_path

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
    expect(page).not_to have_link 'Cadastrar Cardápio'
  end

  it 'e visualiza campos corretamente' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    # Assert
    expect(page).to have_content 'Cadastro de Cardápio'
    expect(page).to have_field 'Nome do Cardápio'
    expect(page).to have_button 'Salvar'
  end

  it 'e falha ao tentar cadastrar sem nome' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome do Cardápio não pode ficar em branco'
  end

  it 'e cadastra com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    fill_in 'Nome do Cardápio', with: 'Café da manhã'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Cardápio cadastrado com sucesso'
    expect(page).to have_content 'Café da manhã'
    expect(page).to have_link 'Adicionar Prato'
    expect(page).to have_content 'Adicionar Bebida'
  end

  it 'e falha ao preencher cardápio sazonal' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    fill_in 'Nome do Cardápio', with: 'Café da manhã'
    fill_in 'Início da validade',	with: 1.day.from_now
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Término da validade deve estar presente no cadastro de pratos sazonais'
  end

  it 'e cadastra cardápio sazonal com sucesso' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Cadastrar cardápio'
    fill_in 'Nome do Cardápio', with: 'Café da manhã'
    fill_in 'Início da validade',	with: 1.day.from_now
    fill_in 'Término da validade',	with: 5.days.from_now
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Cardápio cadastrado com sucesso'
    menu = Menu.last
    expect(menu.valid_from).to eq 1.day.from_now.to_date
    expect(menu.valid_until).to eq 5.days.from_now.to_date
  end
end
