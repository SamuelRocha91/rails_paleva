require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe 'Validação de oferta' do
    context 'Presença obrigatória de' do
      it 'price' do
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
        dish = Dish.create!(
          name: 'lasagna', 
          description: 'massa, queijo e presunto', 
          calories: '185', 
          establishment: establishment
        )
        format = Format.create!(name: 'Porção grande')
        offer = Offer.new(
          format: format,
          item: dish,
          active: true,
        )
        # Act
        result = offer.valid?
        # Assert
        expect(result).to eq false
      end
    end
  end
end
