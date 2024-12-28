require 'rails_helper'

describe 'Usuário que não é ainda cadastrado' do
  context 'admin' do
    it 'consegue acessar a página de cadastro' do
      # Act
      visit root_path
      click_on 'Criar conta'

      # Assert
      expect(current_path).to eq new_user_registration_path
      expect(page).to have_content 'E-mail'
      expect(page).to have_content 'Senha'
      expect(page).to have_content 'Confirme sua senha'
      expect(page).to have_content 'CPF'
      expect(page).to have_content 'Nome'
      expect(page).to have_content 'Sobrenome'
      expect(page).to have_button 'Cadastrar'
    end

    it 'não consegue cadastro sem preencher campos obrigatórios' do
      # Act
      visit root_path
      click_on 'Criar conta'
      fill_in 'E-mail',	with: 'samuel@example.com'
      fill_in 'Senha',	with: '12345678912345'
      fill_in 'Confirme sua senha',	with: '12345678912345'
      click_on 'Cadastrar'

      # Assert
      expect(page).to have_content 'Não foi possível salvar usuário: 3 erros.'
      expect(page).to have_content 'CPF não pode ficar em branco'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Sobrenome não pode ficar em branco'
    end

    it 'não consegue cadastro com email e cpf inválidos' do
      # Arrange
      # Act
      visit root_path
      click_on 'Criar conta'
      fill_in 'E-mail',	with: 'samuel@example'
      fill_in 'Senha',	with: '12345678912345'
      fill_in 'Confirme sua senha',	with: '12345678912345'
      fill_in 'CPF',	with: '12345678912345'
      fill_in 'Nome',	with: 'Samuel'
      fill_in 'Sobrenome',	with: 'Rocha'

      click_on 'Cadastrar'

      # Assert
      expect(page).to have_content 'Não foi possível salvar usuário: 2 erros.'
      expect(page).to have_content 'CPF deve ser um número válido'
      expect(page).to have_content 'E-mail não é válido'
    end

    it 'cadastra-se com sucesso' do
      # Arrange
      # Act
      visit root_path
      click_on 'Criar conta'
      fill_in 'E-mail',	with: 'samuel@example.com'
      fill_in 'Senha',	with: '12345678912345'
      fill_in 'Confirme sua senha',	with: '12345678912345'
      fill_in 'CPF',	with: '22611819572'
      fill_in 'Nome',	with: 'Samuel'
      fill_in 'Sobrenome',	with: 'Rocha'

      click_on 'Cadastrar'

      # Assert
      user = User.last
      expect(page).to have_content 'Você realizou seu registro com sucesso'
      within('header') do
        expect(page).to have_content user.description
        expect(page).to have_button 'Sair'
      end
    end
  end

  context 'employee' do
    it 'pré-cadastrado completa cadastro com sucesso' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )
      TemporaryUser.create(
        email: 'temp@user.com',
        cpf: '03466798507',
        establishment: establishment
      )

      # Act
      visit root_path
      click_on 'Criar conta'
      fill_in 'E-mail',	with: 'temp@user.com'
      fill_in 'Senha',	with: '12345678912345'
      fill_in 'Confirme sua senha',	with: '12345678912345'
      fill_in 'CPF',	with: '03466798507'
      fill_in 'Nome',	with: 'Souza'
      fill_in 'Sobrenome',	with: 'Lopes'

      click_on 'Cadastrar'

      # Assert
      user = User.last
      expect(page).to have_content 'Você realizou seu registro com sucesso'
      within('header') do
        expect(page).to have_content user.description
        expect(page).to have_button 'Sair'
        expect(page).to have_link 'Pedidos'
        expect(page).to have_link 'Cardápios'
        expect(page).to have_link 'Samsung'
        expect(page).not_to have_link 'Pratos'
        expect(page).not_to have_link 'Bebidas'
      end
      expect(user.role).to eq 'employee'
    end
  end
end
