require 'rails_helper'

describe 'Orders API' do
  context 'GET /api/v1/establishment/:code/orders/' do
    it 'lista todos os pedidos do estabelecimento' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer, name: 'Sorocaba')
      customer_two = create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      order_two = Order.create!(establishment: establishment, customer: customer_two)
      order_two.in_preparation!
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order)

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders"

      # Assert
      expect(response.status).to eq(200)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]['code']).to eq order.code
      expect(json_response[0]['status']).to eq 'pending_kitchen_confirmation'
      expect(json_response[1]['code']).to eq order_two.code
      expect(json_response[1]['status']).to eq 'in_preparation'
      expect(json_response[0].keys).not_to include 'updated_at'
      expect(json_response[0]['customer']['name']).to eq 'Sorocaba'
    end

    it 'filtra os pedidos do estabelecimento por status' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer)
      customer_two = create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      order_two = Order.create!(establishment: establishment, customer: customer_two)
      order_two.in_preparation!
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order)

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders?status=in_preparation"

      # Assert
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 1
      expect(json_response[0]['code']).to eq order_two.code
      expect(json_response[0]['status']).to eq 'in_preparation'
    end

    it 'retorna vazio se não houverem pedidos cadastrados' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)

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
      establishment = create(:establishment)
      create(:user, establishment: establishment)

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders"

      # Assert
      expect(response.status).to eq 500
    end

    it 'e falha se o estabelecimento não existir' do
      # Arrange
      # Act
      get '/api/v1/establishment/azds/orders'

      # Assert
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/establishment/:code/orders/:order_code' do
    it 'e lista um pedido específico do estabelecimento' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer, name: 'Sorocaba')
      create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order, note: 'sem cebola')

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders/#{order.code}"

      # Assert
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response['customer']['name']).to eq customer.name
      expect(json_response['status']).to eq 'pending_kitchen_confirmation'
      expect(json_response['order_items'][0]['note']).to eq 'sem cebola'
      expect(json_response['order_items'][0]['offer']['format']['name']).to eq 'Porção grande'
      expect(json_response['order_items'][0]['offer']['item']['name']).to eq 'lasagna'
      expect(json_response.keys).to include 'created_at'
      expect(json_response['customer']['name']).to eq 'Sorocaba'
    end

    it 'retorna status 404 se não for encontrado o pedido' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders/12345"

      # Assert
      expect(response.status).to eq 404
    end

    it 'retorna status 404 se não for encontrado o estabelecimento' do
      # Arrange

      # Act
      get '/api/v1/establishment/555/orders/12345'

      # Assert
      expect(response.status).to eq 404
    end
  end

  context 'PUT /api/v1/establishment/:code/orders/:order_code/in-preparation' do
    it 'e atualiza status de aguardando o aceite para em preparação' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order, note: 'sem cebola')

      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/in-preparation"

      # Assert
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response['code']).to eq order.code
      expect(json_response['status']).to eq 'in_preparation'
    end

    it 'e falha quando se tenta atualizar status indevidamente' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order, note: 'sem cebola')
      order.in_preparation!
      order.ready!

      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/in-preparation"

      # Assert
      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq "Status 'in_progress' não é válido para esse pedido"
    end

    it 'retorna status 404 se não for encontrado o pedido' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders/12345/in-preparation"

      # Assert
      expect(response.status).to eq 404
    end

    it 'retorna status 404 se não for encontrado o estabelecimento' do
      # Arrange

      # Act
      get '/api/v1/establishment/555/orders/12345/in-preparation'

      # Assert
      expect(response.status).to eq 404
    end
  end

  context 'PUT /api/v1/establishment/:code/orders/:order_code/ready' do
    it 'e atualiza status de em preparo para pronto' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order, note: 'sem cebola')
      order.in_preparation!

      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/ready"

      # Assert
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response['code']).to eq order.code
      expect(json_response['status']).to eq 'ready'
    end

    it 'e falha quando se tenta atualizar status indevidamente' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order, note: 'sem cebola')
      order.in_preparation!
      order.ready!

      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/ready"

      # Assert
      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq "Status 'ready' não é válido para esse pedido"
    end

    it 'retorna status 404 se não for encontrado o pedido' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)

      # Act
      get "/api/v1/establishment/#{establishment.code}/orders/12345/ready"

      # Assert
      expect(response.status).to eq 404
    end

    it 'retorna status 404 se não for encontrado o estabelecimento' do
      # Arrange

      # Act
      get '/api/v1/establishment/555/orders/12345/ready'

      # Assert
      expect(response.status).to eq 404
    end
  end

  context 'PUT /api/v1/establishment/:code/orders/:order_code/cancel' do
    it 'e atualiza status de em aguardo para cancelado com sucesso' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order, note: 'sem cebola')

      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/cancel",
          params: { justification: 'cachorro Duki comeu os materiais' }

      # Assert
      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body)
      expect(json_response['code']).to eq order.code
      expect(json_response['status']).to eq 'canceled'
      expect(order.cancellation.justification).to eq 'cachorro Duki comeu os materiais'
    end

    it 'falha sem envio de justificativa' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order, note: 'sem cebola')

      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/cancel"

      # Assert
      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Cancelamento deve ser justificado'
    end

    it 'e falha quando se tenta atualizar cancelar após o ele já ter sido aceito' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order, note: 'sem cebola')
      order.in_preparation!

      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/cancel"

      # Assert
      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq "Status 'canceled' não é válido para esse pedido"
    end

    it 'e falha quando se tenta atualizar cancelar após o pedido estar pronto' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = create(:customer)
      dish = create(:dish, name: 'lasagna', establishment: establishment)
      format = create(:format, name: 'Porção grande')
      menu = create(:menu, establishment: establishment, name: 'Café da manhã')
      MenuItem.create!(item: dish, menu: menu)
      order = Order.create!(establishment: establishment, customer: customer)
      offer = Offer.create!(format: format, item: dish, price: 55)
      OrderItem.create!(offer: offer, order: order, note: 'sem cebola')
      order.in_preparation!
      order.ready!

      # Act
      put "/api/v1/establishment/#{establishment.code}/orders/#{order.code}/cancel"

      # Assert
      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq "Status 'canceled' não é válido para esse pedido"
    end
  end
end
