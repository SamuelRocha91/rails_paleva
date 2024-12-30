require 'rails_helper'

describe 'Usuário acessa a aplicação' do
  it 'não logado é direcionado para a página de login' do
    # Act
    visit root_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  context 'admin' do
    it 'sem estabelecimento cadastrado é direcionado para cadastrar' do
      # Arrange
      create(:user, :within_establishment, email: 'samuel@hotmail.com', password: '12345678910111')

      # Act
      visit root_path
      fill_in 'E-mail',	with: 'samuel@hotmail.com'
      fill_in 'Senha',	with: '12345678910111'
      click_on 'Entrar'

      # Assert
      expect(current_path).to eq new_establishment_path
    end

    it 'sem estabelecimento não consegue acessar outra rota' do
      # Arrange
      user = create(:user, :within_establishment)

      # Act
      login_as user
      visit root_path

      # Assert
      expect(current_path).to eq new_establishment_path
      expect(page).to have_content 'Você precisa criar um estabelecimento antes de continuar.'
    end

    it 'com estabelecimento criado e sem cardápio cadastrado' do
      # Arrange
      establishment = create(:establishment, trade_name: 'Samsung')
      user = create(:user, first_name: 'Samuel', last_name: 'Rocha', email: 'samuel@hotmail.com',
                           establishment: establishment)

      # Act
      login_as user
      visit root_path

      # Assert
      within('header') do
        expect(page).to have_link 'Pratos'
        expect(page).to have_link 'Bebidas'
        expect(page).to have_link 'Cardápios'
        expect(page).to have_link 'Samsung'
        expect(page).to have_content 'Samuel Rocha - samuel@hotmail.com'
      end
      expect(page).to have_content 'Cardápios'
      expect(page).to have_content 'Não existem ainda cardápios cadastrados'
      expect(page).to have_link 'Cadastrar cardápio'
    end

    it 'com estabelecimento criado e cardápios cadastrados' do
      # Arrange
      establishment = create(:establishment)
      user = create(:user, establishment: establishment)

      dish = create(:dish, name: 'Lasagna', establishment: establishment)

      dish_two = create(:dish, name: 'Macarrão', establishment: establishment)

      beverage = create(:beverage, name: 'Cachaça', establishment: establishment)

      menu = Menu.create!(name: 'Café da manhã', establishment: establishment)
      MenuItem.create!(menu: menu, item: beverage)
      MenuItem.create!(menu: menu, item: dish)
      MenuItem.create!(menu: menu, item: dish_two)

      # Act
      login_as user
      visit root_path

      # Assert
      expect(page).to have_content 'Cardápios'
      expect(page).not_to have_content 'Não existem ainda cardápios cadastrados'
      expect(page).to have_content 'Café da manhã'
      expect(page).to have_content 'Cachaça'
      expect(page).to have_content 'Macarrão'
      expect(page).to have_content 'Lasagna'
    end

    it 'visualiza a página de menu e consegue voltar à página principal' do
      # Arrange
      establishment = create(:establishment)
      user = create(:user, establishment: establishment)
      dish = create(:dish, establishment: establishment)
      dish_two = create(:dish, establishment: establishment)
      beverage = create(:beverage, establishment: establishment)

      menu = Menu.create!(name: 'Café da manhã', establishment: establishment)
      MenuItem.create!(menu: menu, item: beverage)
      MenuItem.create!(menu: menu, item: dish)
      MenuItem.create!(menu: menu, item: dish_two)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'
      click_on 'Voltar'

      # Assert
      expect(current_path).to eq root_path
    end
  end
end
