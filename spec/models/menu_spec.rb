require 'rails_helper'

RSpec.describe Menu, type: :model do
  context 'Validações' do
    it 'Presença obrigatória de #name' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      menu = Menu.new(establishment: establishment, name: '')

      # Act
      result = menu.valid?

      # Assert
      expect(result).to eq false
    end

    it '#name deve ter ao menos três caracteres' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      menu = Menu.new(establishment: establishment, name: 'Ab')

      # Act
      result = menu.valid?

      # Assert
      expect(result).to eq false
    end

    it '#name deve ser único para dado restaurante' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      Menu.create!(establishment: establishment, name: 'Café da manhã')
      menu_two = Menu.new(establishment: establishment, name: 'Café da manhã')

      # Act
      result = menu_two.valid?

      # Assert
      expect(result).to eq false
    end

    it '#name pode ser repetido por usuários diferentes' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      establishment_two = create(:establishment)
      create(:user, establishment: establishment_two)
      Menu.create!(establishment: establishment, name: 'Café da manhã')
      menu_two = Menu.new(establishment: establishment_two, name: 'Café da manhã')

      # Act
      result = menu_two.valid?

      # Assert
      expect(result).to eq true
    end

    it '#valid_from é obrigatório se #valid_until for preenchido' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      menu = Menu.new(establishment: establishment, name: 'Café da manhã', valid_until: 5.days.from_now)

      # Act
      result = menu.valid?

      # Assert
      expect(result).to eq false
    end

    it '#valid_until é obrigatório se #valid_from for preenchido' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      menu = Menu.new(establishment: establishment, name: 'Café da manhã', valid_from: 5.days.from_now)

      # Act
      result = menu.valid?

      # Assert
      expect(result).to eq false
    end

    it '#valid_until deve ser maior que #valid_from' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      menu = Menu.new(establishment: establishment, name: 'Café da manhã', valid_from: 5.days.from_now,
                      valid_until: 1.day.from_now)

      # Act
      result = menu.valid?

      # Assert
      expect(result).to eq false
    end
  end
end
