require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Após criar um pedido' do
    it 'Deve ser setado com status correto' do
      # Arrange
      user = User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572'
      )
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
        user: user
      )

      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')

      order = Order.new(establishment: establishment, customer: customer)
      # Act
      order.save

      # Assert
      expect(order.status).to eq 'pending_kitchen_confirmation'
    end

    it 'Deve gerar código alfanumérico' do
      # Arrange
      user = User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572'
      )
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
        user: user
      )

      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')

      order = Order.new(establishment: establishment, customer: customer)
      # Act
      order.save

      # Assert
      expect(order.code.length).to eq 8
    end
  end
end
