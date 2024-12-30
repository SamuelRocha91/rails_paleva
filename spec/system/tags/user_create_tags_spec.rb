require 'rails_helper'

describe 'Usuário acessa página de marcadores' do
  it 'e deve estar autenticado' do
    # Act
    visit tags_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'não deve ter role :employee' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)

    # Act
    login_as user
    visit tags_path

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e visualiza página corretamente' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    Tag.create!(name: 'Apimentado')
    Tag.create!(name: 'Vegano')
    Tag.create!(name: 'Japonesa')
    Tag.create!(name: 'Massas')

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'Marcadores'

    # Assert
    expect(page).to have_content 'Marcadores Disponíveis'
    expect(page).to have_link 'Cadastrar novo marcador'
    expect(page).to have_content 'Apimentado'
    expect(page).to have_content 'Vegano'
    expect(page).to have_content 'Japonesa'
    expect(page).to have_content 'Massas'
  end

  it 'e visualiza mensagem instrutiva se não houver tags cadastradas' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'Marcadores'

    # Assert
    expect(page).to have_content 'Marcadores Disponíveis'
    expect(page).to have_content 'Não existem ainda marcadores cadastrados'
  end

  it 'e visualiza página de cadastro de tags corretamente' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'Marcadores'
    click_on 'Cadastrar novo marcador'

    # Assert
    expect(page).to have_content 'Cadastro de novo marcador'
    expect(page).to have_field 'Nome do marcador'
    expect(page).to have_button 'Salvar'
  end

  it 'e falha ao cadastrar marcador sem campo obrigatório' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'Marcadores'
    click_on 'Cadastrar novo marcador'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Nome do marcador não pode ficar em branco'
  end

  it 'e cadastra marcador com sucesso previamente' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'Marcadores'
    click_on 'Cadastrar novo marcador'
    fill_in 'Nome do marcador',	with: 'Apimentado'
    click_on 'Salvar'

    # Assert
    expect(current_path).to eq tags_path
    expect(page).to have_content 'Marcador cadastrado com sucesso'
    expect(page).to have_content 'Apimentado'
  end

  it 'e cadastra tags direto no formulário de criação de prato' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'Cadastrar novo prato'
    fill_in 'Nome',	with: 'Lasagna'
    fill_in 'Descrição',	with: 'pao com ovo'
    fill_in 'Quantidade de calorias',	with: '185'
    fill_in 'Características',	with: 'misto, parmegiana'
    fill_in 'Quantidade de calorias',	with: '105'
    click_on 'Salvar'
    click_on 'Lasagna'

    # Assert
    expect(page).to have_content '#misto #parmegiana'
  end

  it 'e cadastra tags no formulário de edição de pratos' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)
    create(:dish, name: 'Lasagna', description: 'queijo, presunto e molho', establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'Lasagna'
    click_on 'Editar prato'
    fill_in 'Características',	with: 'misto, parmegiana'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content '#misto #parmegiana'
  end
end
