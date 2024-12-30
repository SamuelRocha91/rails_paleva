require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe 'Validação de oferta de prato' do
    context 'Presença obrigatória de' do
      it 'price' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        dish = create(:dish, name: 'lasagna', establishment: establishment)
        format = create(:format, name: 'Porção grande')
        offer = Offer.new(format: format, item: dish)

        # Act
        result = offer.valid?

        # Assert
        expect(result).to eq false
      end
    end

    context 'após criar uma oferta' do
      it 'o campo active deve ser true' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        format = create(:format, name: 'Porção grande')
        dish = create(:dish, name: 'lasagna', establishment: establishment)
        offer = Offer.new(format: format, item: dish, price: 25)

        # Act
        offer.save!

        # Assert
        expect(offer.active).to eq true
      end

      it 'o campo start offer deve ter um valor' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        format = create(:format, name: 'Porção grande')
        dish = create(:dish, name: 'lasagna', establishment: establishment)
        offer = Offer.new(format: format, item: dish, price: 25)

        # Act
        offer.save!

        # Assert
        expect(offer.start_offer).not_to be_nil
        expect(offer.end_offer).to be_nil
      end
    end

    context 'após desativar uma oferta' do
      it 'o campo end_offer deve ser true' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        format = create(:format, name: 'Porção grande')
        dish = create(:dish, name: 'lasagna', establishment: establishment)
        offer = Offer.new(format: format, item: dish, price: 25, active: false)

        # Act
        offer.save!

        # Assert
        expect(offer.end_offer).not_to be_nil
      end
    end
  end

  describe 'Validação de oferta de bebida' do
    context 'Presença obrigatória de' do
      it 'price' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        beverage = create(:beverage, establishment: establishment)
        format = create(:format, name: 'Bombinha 50ml')
        offer = Offer.new(format: format, item: beverage)

        # Act
        result = offer.valid?

        # Assert
        expect(result).to eq false
      end
    end

    context 'após criar uma oferta' do
      it 'o campo active deve ser true' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        beverage = create(:beverage, establishment: establishment)
        format = create(:format, name: 'Bombinha 50ml')
        offer = Offer.create!(format: format, item: beverage, price: 25)

        # Act
        offer.save!

        # Assert
        expect(offer.active).to eq true
      end

      it 'o campo start offer deve ter um valor' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        beverage = create(:beverage, establishment: establishment)
        format = create(:format, name: 'Bombinha 50ml')
        offer = Offer.create!(format: format, item: beverage, price: 25)

        # Act
        offer.save!

        # Assert
        expect(offer.start_offer).not_to be_nil
      end
    end

    context 'após desativar uma oferta' do
      it 'o campo end_offer deve ser true' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        beverage = create(:beverage, establishment: establishment)
        format = create(:format, name: 'Bombinha 50ml')
        offer = Offer.create!(format: format, item: beverage, price: 25, active: false)

        # Act
        offer.save!

        # Assert
        expect(offer.end_offer).not_to be_nil
      end
    end
  end
end
