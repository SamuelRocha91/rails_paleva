require 'rails_helper'

describe 'Usuário acessa página de login' do
  context 'admin' do
    it 'e faz login com sucesso' do
      # Arrange
      user = create(:user, email: 'samuel@hotmail.com', password: '12345678910111')

      # Act
      visit root_path
      fill_in 'E-mail',	with: 'samuel@hotmail.com'
      fill_in 'Senha',	with: '12345678910111'
      click_on 'Entrar'

      # Assert
      expect(page).to have_content "#{user.first_name} #{user.last_name} - #{user.email}"
    end

    it 'e faz logout' do
      # Arrange
      user = create(:user, email: 'samuel@hotmail.com', password: '12345678910111')

      # Act
      visit root_path
      fill_in 'E-mail',	with: 'samuel@hotmail.com'
      fill_in 'Senha',	with: '12345678910111'
      click_on 'Entrar'
      within 'header' do
        click_on 'Sair'
      end

      # Assert
      within 'header' do
        expect(page).not_to have_content "#{user.first_name} #{user.last_name} - #{user.email}"
      end
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'employee' do
    it 'e faz login com sucesso' do
      # Arrange
      establishment = create(:establishment)
      user = create(:user, email: 'samuel@hotmail.com', password: '12345678910111', role: 1,
                           establishment: establishment)

      # Act
      visit root_path
      fill_in 'E-mail',	with: 'samuel@hotmail.com'
      fill_in 'Senha',	with: '12345678910111'
      click_on 'Entrar'

      # Assert
      expect(page).to have_content "#{user.first_name} #{user.last_name} - #{user.email}"
    end

    it 'e faz logout' do
      # Arrange
      establishment = create(:establishment)
      user = create(:user, email: 'samuel@hotmail.com', password: '12345678910111', role: 1,
                           establishment: establishment)

      # Act
      visit root_path
      fill_in 'E-mail',	with: 'samuel@hotmail.com'
      fill_in 'Senha',	with: '12345678910111'
      click_on 'Entrar'
      within 'header' do
        click_on 'Sair'
      end

      # Assert
      within 'header' do
        expect(page).not_to have_content "#{user.first_name} #{user.last_name} - #{user.email}"
      end
      expect(current_path).to eq new_user_session_path
    end
  end
end
# 