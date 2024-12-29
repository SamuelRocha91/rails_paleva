require 'rails_helper'

describe 'Usuário faz pré-cadastro de funcionários' do
  it 'e deve estar autenticado' do
    # Arrange
    establishment = FactoryBot.create(:establishment)
    create(:user, establishment: establishment)

    # Act
    visit user_new_establishment_path establishment.id

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e falha por dados inválidos' do
    # Arrange
    establishment = FactoryBot.create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path

    click_on establishment.trade_name
    click_on 'Gerenciar usuários do estabelecimento'
    click_on 'Fazer pré-cadastro de usuário'
    fill_in 'E-mail',	with: 'mariazinha@gmail'
    fill_in 'CPF',	with: '03466798507'

    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'E-mail deve ser válido'
  end

  it 'cpf deve ser único na aplicação' do
    # Arrange
    establishment = FactoryBot.create(:establishment)
    user = create(:user, establishment: establishment, cpf: '22611819572')

    # Act
    login_as user
    visit root_path

    click_on establishment.trade_name
    click_on 'Gerenciar usuários do estabelecimento'
    click_on 'Fazer pré-cadastro de usuário'
    fill_in 'E-mail',	with: 'mariazinha@gmail.com'
    fill_in 'CPF',	with: '22611819572'

    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Cpf já está em uso por um usuário existente'
  end

  it 'e faz pré-cadastro de funcionário com sucesso' do
    # Arrange
    establishment = FactoryBot.create(:establishment)
    user = create(:user, establishment: establishment)

    # Act
    login_as user
    visit root_path

    click_on establishment.trade_name
    click_on 'Gerenciar usuários do estabelecimento'
    click_on 'Fazer pré-cadastro de usuário'
    fill_in 'E-mail',	with: 'mariazinha@gmail.com'
    fill_in 'CPF',	with: '03466798507'

    click_on 'Salvar'

    # Assert
    expect(page).to have_content 'Pré-cadastro realizado com sucesso'
  end

  it 'e visualiza estado de usuários vinculados ao seu estabelecimento' do
    # Arrange
    establishment = FactoryBot.create(:establishment)
    user = create(:user, establishment: establishment)

    temporary_user = create(:temporary_user, email: 'temporario@gamail.com', cpf: CPF.generate,
                                             establishment: establishment)

    user_two = create(:user, establishment: establishment, first_name: 'Empregado', last_name: 'salario',
                             email: 'empregado@hotmail.com', password: '12345678910111', cpf: CPF.generate, role: 1)

    # Act
    login_as user
    visit root_path

    click_on establishment.trade_name
    click_on 'Gerenciar usuários do estabelecimento'

    # Assert
    expect(page).to have_content 'empregado@hotmail.com'
    expect(page).to have_content user_two.cpf
    expect(page).to have_content 'Cadastrado'
    expect(page).to have_content 'temporario@gamail.com'
    expect(page).to have_content temporary_user.cpf
    expect(page).to have_content 'Pré-cadastrado'
  end
end
