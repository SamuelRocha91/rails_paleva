require 'rails_helper'

RSpec.describe Beverage, type: :model do
  describe 'Validações de bebidas' do
    context 'presença obrigatória de' do
      it 'name' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        beverage = Beverage.new(name: '', description: 'alcool delicioso baiano', calories: '185',
                                establishment: establishment, is_alcoholic: true)

        # Act
        result = beverage.valid?

        # Assert
        expect(result).to eq false
      end

      it 'description' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        beverage = Beverage.new(name: 'Cachaça', description: '', calories: '185', establishment: establishment,
                                is_alcoholic: true)

        # Act
        result = beverage.valid?

        # Assert
        expect(result).to eq false
      end
    end
  end
end
