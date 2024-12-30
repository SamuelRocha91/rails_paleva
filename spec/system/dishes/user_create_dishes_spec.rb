require 'rails_helper'

describe 'Usuário acessa formulário de criar pratos' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = FactoryBot.create(:establishment)
    create(:user, establishment: establishment)
    7.times do |i|
      create(:operating_hour, week_day: i)
    end

    # Act
    visit new_establishment_dish_path establishment.id

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'deve ser :admin' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, :employee, establishment: establishment)

    # Act
    login_as user
    visit new_establishment_dish_path establishment.id

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para acessar esse recurso'
  end

  it 'e vê os campos corretamente' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'Cadastrar novo prato'

    # Assert
    expect(current_path).to eq new_establishment_dish_path establishment.id
    expect(page).to have_content 'Cadastro de novo prato'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Quantidade de calorias'
    expect(page).to have_field 'Imagem do prato'
    expect(page).to have_button 'Salvar'
  end

  it 'falha no cadastro por falta de campo obrigatório' do
    # Arrange
    establishment = create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path
    click_on 'Pratos'
    click_on 'Cadastrar novo prato'
    fill_in 'Nome',	with: 'Lasagna'
    fill_in 'Quantidade de calorias',	with: '185'
    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Descrição não pode ficar em branco'
  end

  it 'e cadastra prato com sucesso' do
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
    attach_file 'Imagem', Rails.root.join('spec/support/pao.jpg')
    click_on 'Salvar'

    # Assert
    expect(current_path).to eq establishment_dishes_path(establishment.id)
    expect(page).to have_content 'Prato cadastrado com sucesso'
    expect(page).to have_content 'Nome: Lasagna'
    expect(page).to have_content 'Descrição: pao com ovo'
    expect(page).to have_content 'Status: Ativo'
  end
end
