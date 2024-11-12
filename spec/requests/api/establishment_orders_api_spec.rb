require 'rails_helper'

describe 'Orders API' do
  context 'GET /api/v1/establishment/:code/orders/' do
    it 'sem status, lista todos os pedidos do estabelecimento' do
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

      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      customer_two = Customer.create!(name: 'Ana', email: 'ana@gmail.com')

      dish = Dish.create!(
            name: 'lasagna', 
            description: 'massa, queijo e presunto', 
            calories: '185', 
            establishment: establishment
      )
      format = Format.create!(name: 'Porção grande')

      order = Order.create!(establishment: establishment, customer: customer)
      order_two = Order.create!(establishment: establishment, customer: customer_two)
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
  end
  
end