require 'rails_helper'

describe 'Orders API' do
  context 'GET /api/v1/establishment/:code/orders/' do
    it 'lista todos os pedidos do estabelecimento' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )

      customer = Customer.create!(
        name: 'Samuel',
        email: 'sam@gmail.com'
      )
      customer_two = Customer.create!(
        name: 'Ana', 
        email: 'ana@gmail.com'
      )

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
      order_two.in_preparation!
      offer = Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      OrderItem.create!(offer: offer, order: order )

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders"
  
      # Assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]["code"]).to eq order.code
      expect(json_response[0]["status"]).to eq 'pending_kitchen_confirmation'
      expect(json_response[1]["code"]).to eq order_two.code
      expect(json_response[1]["status"]).to eq 'in_preparation'
      expect(json_response[0].keys).not_to include 'updated_at'
      expect(json_response[0]["customer"]["name"]).to eq 'Samuel'
    end

    it 'filtra os pedidos do estabelecimento por status' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )

      customer = Customer.create!(
        name: 'Samuel', 
        email: 'sam@gmail.com'
      )
      customer_two = Customer.create!(
        name: 'Ana', 
        email: 'ana@gmail.com'
      )

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
      order_two.in_preparation!
      offer = Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      OrderItem.create!(offer: offer, order: order )

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders?status=in_preparation"

      # Assert
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 1
      expect(json_response[0]["code"]).to eq order_two.code
      expect(json_response[0]["status"]).to eq 'in_preparation'
    end

    it 'retorna vazio se não houverem pedidos cadastrados' do
      # Arrange
       establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )
      # Act
      get "/api/v1/establishment/#{establishment.code}/orders"

      # Assert
      expect(response.status).to eq 200
      expect(response.body).to eq '[]' 
    end

    it 'e falha se houver um erro interno' do
      # Arrange
      allow(Establishment).to receive(:find_by)
                               .and_raise(ActiveRecord::ActiveRecordError)
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders"

      # Assert
      expect(response.status).to eq 500
    end

    it 'e falha se o estabelecimento não existir' do
      # Arrange
      # Act
      get "/api/v1/establishment/azds/orders"

      # Assert
      expect(response.status).to eq 404  
    end
  end
  
  context 'GET /api/v1/establishment/:code/orders/:order_code' do
     it 'e lista um pedido específico do estabelecimento' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )

      customer = Customer.create!(
        name: 'Samuel',
        email: 'sam@gmail.com'
      )

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
      offer = Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      OrderItem.create!(
        offer: offer, 
        order: order, 
        note: 'sem cebola' 
      )

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders/#{order.code}"
  
      # Assert
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["customer"]["name"]).to eq customer.name
      expect(json_response["status"]).to eq 'pending_kitchen_confirmation'
      expect(json_response["order_items"][0]["note"]).to eq 'sem cebola'
      expect(json_response["order_items"][0]["offer"]["format"]["name"]
                                                ).to eq 'Porção grande'
      expect(json_response["order_items"][0]["offer"]["item"]["name"]
                                                ).to eq 'lasagna'
      expect(json_response.keys).to include 'created_at'
      expect(json_response["customer"]["name"]).to eq 'Samuel'
    end

    it 'retorna status 404 se não for encontrado o pedido' do
      # Arrange
       establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )
  
      # Act
      get "/api/v1/establishment/#{establishment.code}/orders/12345"

      # Assert
      expect(response.status).to eq 404
    end

    it 'retorna status 404 se não for encontrado o estabelecimento' do
      # Arrange
  
      # Act
      get "/api/v1/establishment/555/orders/12345"

      # Assert
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/establishment/:code/orders/:order_code/in-preparation' do
    it 'e atualiza status de aguardando o aceite para em preparação' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )

      customer = Customer.create!(
        name: 'Samuel',
        email: 'sam@gmail.com'
      )

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
      offer = Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      OrderItem.create!(
        offer: offer, 
        order: order, 
        note: 'sem cebola' 
      )
  
      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/in-preparation"
  
      # Assert
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["code"]).to eq order.code
      expect(json_response["status"]).to eq 'in_preparation'
    end

    it 'e falha quando se tenta atualizar status indevidamente' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )
      customer = Customer.create!(
        name: 'Samuel',
        email: 'sam@gmail.com'
      )
      dish = Dish.create!(
            name: 'lasagna', 
            description: 'massa, queijo e presunto', 
            calories: '185', 
            establishment: establishment
      )
      format = Format.create!(name: 'Porção grande')
      order = Order.create!(
        establishment: establishment, 
        customer: customer,
      )
      offer = Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      OrderItem.create!(
        offer: offer, 
        order: order, 
        note: 'sem cebola' 
      )
      order.in_preparation!
      order.ready!

      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/in-preparation"
  
      # Assert
      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body)
      expect(json_response["message"]
                             ).to eq "Status 'in_progress' não é válido para esse pedido"
    end

    it 'retorna status 404 se não for encontrado o pedido' do
      # Arrange
       establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )
  
      # Act
      get "/api/v1/establishment/#{establishment.code}/orders/12345/in-preparation"

      # Assert
      expect(response.status).to eq 404
    end

    it 'retorna status 404 se não for encontrado o estabelecimento' do
      # Arrange
  
      # Act
      get "/api/v1/establishment/555/orders/12345/in-preparation"

      # Assert
      expect(response.status).to eq 404
    end
    
  end

  context 'GET /api/v1/establishment/:code/orders/:order_code/ready' do
    it 'e atualiza status de em preparo para pronto' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )

      customer = Customer.create!(
        name: 'Samuel',
        email: 'sam@gmail.com'
      )

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
      offer = Offer.create!(
        format: format,
        item: dish,
        price: 55
      )
      OrderItem.create!(
        offer: offer, 
        order: order, 
        note: 'sem cebola' 
      )
      order.in_preparation!
  
      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/ready"
  
      # Assert
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response["code"]).to eq order.code
      expect(json_response["status"]).to eq 'ready'
    end

  end
end