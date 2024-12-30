require 'rails_helper'

RSpec.describe Dish, type: :model do
  describe 'Validações de pratos' do
    context 'presença obrigatória de' do
      it 'name' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
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
        establishment = create(:establishment)
        create(:user, establishment: establishment)
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
