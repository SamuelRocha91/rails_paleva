require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe 'Validações de pratos' do
    context 'presença obrigatória de' do
      it 'name' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'', trade_name: 'Samsumg', legal_name: 'Samsumg LTDA', cnpj: '56924048000140', phone_number: '71992594946', address: 'Rua das Alamedas avenidas' )
        establishment.user = user
        dish = Dish.new(name: '', description: 'massa, queijo e presunto com molho de tomate')
        dish.establishment = establishment
        # Act
        result = dish.valid?
        # Assert
        expect(result).to eq false
      end

      it 'description' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'', trade_name: 'Samsumg', legal_name: 'Samsumg LTDA', cnpj: '56924048000140', phone_number: '71992594946', address: 'Rua das Alamedas avenidas' )
        establishment.user = user
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
