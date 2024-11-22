require 'rails_helper'

describe 'Usuário acompanha um pedido' do
  context '#admin do seu estabelecimento' do  
    it 'e deve estar autenticado' do
      # ACT
      visit orders_path
    
      # Assert
      expect(current_path).to eq new_user_session_path  
    end

    it 'com sucesso' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      user = User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )

      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      customer_two = Customer.create!(name: 'Ana', email: 'ana@gmail.com')

      dish = Dish.create!(
            name: 'lasagna', 
            description: 'massa, queijo e presunto', 
            calories: '185', 
            establishment: establishment
      )
      format = Format.create!(name: 'Porção grande')

      order = Order.create!(
        establishment: establishment, 
        customer: customer
      )
      order_two = Order.create!(
        establishment: establishment, 
        customer: customer_two
      )

      offer = Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      menu = Menu.create!(
        establishment: establishment, 
        name: 'Café da manhã'
      )
      MenuItem.create!(item: dish, menu: menu)

      OrderItem.create!(offer: offer, order: order )

      # Act
      login_as user
      visit root_path
      click_on 'Pedidos'

      # Assert
      within('table') do
        expect(page).to have_content 'Acompanhamento de pedidos'
        expect(page).to have_content 'Data'
        expect(page).to have_content 'Preço'    
        expect(page).to have_content 'Pedido'
        expect(page).to have_content 'Cliente'
        expect(page).to have_content 'Status'
        expect(page).to have_content 'R$ 55,00'
        expect(page).to have_content "#{order.code}"
        expect(page).to have_content "Aguardando confirmação da cozinha"
        expect(page).to have_content "#{order_two.code}"
      end 
    end
  end

  context '#usuário comum' do
    it 'tem acesso a pesquisa de pedido mesmo não logado' do
      # Act
      visit root_path

      # Assert
      within('header') do
        expect(page).to have_field  'Possui um pedido? Acompanhe aqui'
        expect(page).to have_field(placeholder: 'digite o código do pedido', class: 'form-control w-75')
        expect(page).to have_button 'Pesquisar'
      end
    end

    it 'pesquisa por um pedido inexistente' do
      # Act
      visit root_path
      fill_in 'Possui um pedido? Acompanhe aqui',	with: '45614567'
      click_on 'Pesquisar'

      # Assert
      expect(page).to have_content 'Não foi possível encontar o pedido. Favor, verifique o código.'
    end

    it 'acompanha dados do pedido com sucesso' do
      # Arrange
      
      establishment = Establishment.create!(
      email: 'sam@gmail.com', 
      trade_name: 'Samsung', 
      legal_name: 'Samsung LTDA', 
      cnpj: '56924048000140',
      phone_number: '71992594946', 
      address: 'Rua das Alamedas avenidas',
      )
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(
        establishment: establishment, 
        customer: customer
      )
      order.in_preparation!
      order.ready!
      order.delivered!

      # Act
      visit root_path
      fill_in 'Possui um pedido? Acompanhe aqui',	with: order.code
      click_on 'Pesquisar'

      # Assert
      expect(page).to have_content 'Nome Social: Samsung'
      expect(page).to have_content 'Telefone: (71) 99259-4946'
      expect(page).to have_content 'E-mail: sam@gmail.com'
      expect(page).to have_content 'Dados do estabelecimento'  
      within('table') do
        expect(page).to have_content 'Data de criação'
        expect(page).to have_content 'Data de entrega'
        expect(page).to have_content 'Data de aceite do pedido'
        expect(page).to have_content 'Data de conclusão do pedido'
        expect(page).to have_content "#{Time.current.to_date.strftime("%d-%m-%Y")}"
      end
    end
  end  
end