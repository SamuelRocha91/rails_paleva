require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    # ACT
    visit new_order_path

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  context 'admin' do
    it 'e visualiza página de cadastro de observações' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )
      menu = Menu.create!(
        establishment: establishment,
        name: 'Café da manhã'
      )
      Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      MenuItem.create!(item: dish, menu: menu)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'
      find('.Porção-grande-lasagna').click

      # Assert
      expect(page).to have_content 'Adicionar Porção ao Pedido'
      expect(page).to have_field 'Observação'
      expect(page).to have_button 'Adicionar ao Pedido'
    end

    it 'e adiciona item ao pedido' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      MenuItem.create!(item: dish, menu: menu)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'
      find('.Porção-grande-lasagna').click
      fill_in 'Observação',	with: 'Sem cebola'
      click_on 'Adicionar ao Pedido'

      # Assert
      expect(page).to have_content 'Visualizar Pedido'
      expect(page).to have_content 'Porção grande - lasagna - R$ 55,00 - Observação: Sem cebola'
      expect(page).to have_link 'Finalizar Pedido'
      expect(page).to have_content 'Continuar adicionando itens'
    end

    it 'de mais de um cardápio diferente' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      menu_two = Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )
      dish_two = Dish.create!(
        name: 'feijoada',
        description: 'feijao e condimentos',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      Offer.create!(
        format: format,
        item: dish_two,
        price: 33
      )

      MenuItem.create!(item: dish, menu: menu)
      MenuItem.create!(item: dish_two, menu: menu_two)

      # Act
      login_as user
      visit root_path
      click_on 'Almoço'
      find('.Porção-grande-feijoada').click
      fill_in 'Observação',	with: 'Sem sal'
      click_on 'Adicionar ao Pedido'
      click_on 'Continuar adicionando itens'
      click_on 'Café da manhã'
      find('.Porção-grande-lasagna').click
      fill_in 'Observação',	with: 'Sem cebola'
      click_on 'Adicionar ao Pedido'

      # Assert
      expect(page).to have_content 'Visualizar Pedido'
      expect(page).to have_content 'Porção grande - lasagna - R$ 55,00 - Observação: Sem cebola'
      expect(page).to have_content 'Porção grande - feijoada - R$ 33,00 - Observação: Sem sal'
      expect(page).to have_link 'Finalizar Pedido'
      expect(page).to have_content 'Continuar adicionando itens'
    end

    it 'e visualiza formulário de finalização de pedido' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      MenuItem.create!(item: dish, menu: menu)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'
      find('.Porção-grande-lasagna').click
      fill_in 'Observação',	with: 'Sem cebola'
      click_on 'Adicionar ao Pedido'
      click_on 'Finalizar Pedido'

      # Assert
      expect(page).to have_content 'Dados do cliente'
      expect(page).to have_content 'E-mail'
      expect(page).to have_content 'CPF'
      expect(page).to have_content 'Telefone'
      expect(page).to have_content 'Nome do cliente'
      expect(page).to have_button 'Salvar'
    end

    it 'falha ao tentar vincular cliente ao pedido' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      MenuItem.create!(item: dish, menu: menu)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'
      find('.Porção-grande-lasagna').click
      fill_in 'Observação',	with: 'Sem cebola'
      click_on 'Adicionar ao Pedido'
      click_on 'Finalizar Pedido'
      fill_in 'E-mail',	with: ''
      fill_in 'Nome',	with: 'Samuel'
      click_on 'Salvar'

      # Assert
      expect(page).to have_content 'E-mail ou telefone deve ser preenchido'
    end

    it 'com sucesso' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      MenuItem.create!(item: dish, menu: menu)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'

      find('.Porção-grande-lasagna').click

      fill_in 'Observação',	with: 'Sem cebola'
      click_on 'Adicionar ao Pedido'

      click_on 'Finalizar Pedido'

      fill_in 'E-mail',	with: 'samuel@gmail.com'
      fill_in 'Nome do cliente',	with: 'Samuel'
      fill_in 'Telefone',	with: '71992594946'
      click_on 'Salvar'

      # Assert
      expect(page).to have_content 'Pedido realizado com sucesso'
      order = Order.last
      expect(order.order_items.length).to eq 1
      expect(order.order_items[0].note).to eq 'Sem cebola'
    end
  end

  context 'employee' do
    it 'e visualiza página de cadastro de observações' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment,
        role: 1
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      MenuItem.create!(item: dish, menu: menu)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'
      find('.Porção-grande-lasagna').click

      # Assert
      expect(page).to have_content 'Adicionar Porção ao Pedido'
      expect(page).to have_field 'Observação'
      expect(page).to have_button 'Adicionar ao Pedido'
    end

    it 'e adiciona item ao pedido' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment,
        role: 1
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      MenuItem.create!(item: dish, menu: menu)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'
      find('.Porção-grande-lasagna').click
      fill_in 'Observação',	with: 'Sem cebola'
      click_on 'Adicionar ao Pedido'

      # Assert
      expect(page).to have_content 'Visualizar Pedido'
      expect(page).to have_content 'Porção grande - lasagna - R$ 55,00 - Observação: Sem cebola'
      expect(page).to have_link 'Finalizar Pedido'
      expect(page).to have_content 'Continuar adicionando itens'
    end

    it 'de mais de um cardápio diferente' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment,
        role: 1
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      menu_two = Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )
      dish_two = Dish.create!(
        name: 'feijoada',
        description: 'feijao e condimentos',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      Offer.create!(
        format: format,
        item: dish_two,
        price: 33
      )

      MenuItem.create!(item: dish, menu: menu)
      MenuItem.create!(item: dish_two, menu: menu_two)

      # Act
      login_as user
      visit root_path
      click_on 'Almoço'
      find('.Porção-grande-feijoada').click
      fill_in 'Observação',	with: 'Sem sal'
      click_on 'Adicionar ao Pedido'
      click_on 'Continuar adicionando itens'
      click_on 'Café da manhã'
      find('.Porção-grande-lasagna').click
      fill_in 'Observação',	with: 'Sem cebola'
      click_on 'Adicionar ao Pedido'

      # Assert
      expect(page).to have_content 'Visualizar Pedido'
      expect(page).to have_content 'Porção grande - lasagna - R$ 55,00 - Observação: Sem cebola'
      expect(page).to have_content 'Porção grande - feijoada - R$ 33,00 - Observação: Sem sal'
      expect(page).to have_link 'Finalizar Pedido'
      expect(page).to have_content 'Continuar adicionando itens'
    end

    it 'e visualiza formulário de finalização de pedido' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment,
        role: 1
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      MenuItem.create!(item: dish, menu: menu)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'
      find('.Porção-grande-lasagna').click
      fill_in 'Observação',	with: 'Sem cebola'
      click_on 'Adicionar ao Pedido'
      click_on 'Finalizar Pedido'

      # Assert
      expect(page).to have_content 'Dados do cliente'
      expect(page).to have_content 'E-mail'
      expect(page).to have_content 'CPF'
      expect(page).to have_content 'Telefone'
      expect(page).to have_content 'Nome do cliente'
      expect(page).to have_button 'Salvar'
    end

    it 'falha ao tentar vincular cliente ao pedido' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment,
        role: 1
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      MenuItem.create!(item: dish, menu: menu)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'
      find('.Porção-grande-lasagna').click
      fill_in 'Observação',	with: 'Sem cebola'
      click_on 'Adicionar ao Pedido'
      click_on 'Finalizar Pedido'
      fill_in 'E-mail',	with: ''
      fill_in 'Nome',	with: 'Samuel'
      click_on 'Salvar'

      # Assert
      expect(page).to have_content 'E-mail ou telefone deve ser preenchido'
    end

    it 'com sucesso' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      user = User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment,
        role: 1
      )
      menu = Menu.create!(establishment: establishment, name: 'Café da manhã')
      Menu.create!(establishment: establishment, name: 'Almoço')

      dish = Dish.create!(
        name: 'lasagna',
        description: 'massa, queijo e presunto',
        calories: '185',
        establishment: establishment
      )

      format = Format.create!(name: 'Porção grande')
      format_two = Format.create!(name: 'Porção média')

      Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      Offer.create!(
        format: format_two,
        item: dish,
        price: 25
      )

      MenuItem.create!(item: dish, menu: menu)

      # Act
      login_as user
      visit root_path
      click_on 'Café da manhã'

      find('.Porção-grande-lasagna').click

      fill_in 'Observação',	with: 'Sem cebola'
      click_on 'Adicionar ao Pedido'

      click_on 'Finalizar Pedido'

      fill_in 'E-mail',	with: 'samuel@gmail.com'
      fill_in 'Nome do cliente',	with: 'Samuel'
      fill_in 'Telefone',	with: '71992594946'
      click_on 'Salvar'

      # Assert
      expect(page).to have_content 'Pedido realizado com sucesso'
      order = Order.last
      expect(order.order_items.length).to eq 1
      expect(order.order_items[0].note).to eq 'Sem cebola'
    end
  end
end
