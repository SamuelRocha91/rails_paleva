require 'rails_helper'

RSpec.describe Beverage, type: :model do
  describe 'Validações de bebidas' do
    context 'presença obrigatória de' do
      it 'name' do
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
        beverage = Beverage.new(name: '', description: 'alcool delicioso baiano', 
                 calories: '185', establishment: establishment, is_alcoholic: true)
        # Act
        result = beverage.valid?
        # Assert
        expect(result).to eq false
      end

      it 'description' do
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
        beverage = Beverage.new(name: 'Cachaça', description: '', 
                 calories: '185', establishment: establishment, is_alcoholic: true)
        # Act
        result = beverage.valid?
        # Assert
        expect(result).to eq false
      end
    end
  end
end
