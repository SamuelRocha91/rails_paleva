require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe 'Validações de pratos' do
    context 'presença obrigatória de' do
      it 'name' do
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
        dish = Dish.new(
          name: '', 
          description: 'massa, queijo e presunto com molho de tomate'
        )
        dish.establishment = establishment

        # Act
        result = dish.valid?

        # Assert
        expect(result).to eq false
      end

      it 'description' do
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
        dish = Dish.new(name: 'Lasagna', description: '')
        dish.establishment = establishment

        # Act
        result = dish.valid?

        # Assert
        expect(result).to eq false
      end
    end
  end
end
