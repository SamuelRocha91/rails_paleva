require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe 'Validação de oferta de prato' do
    context 'Presença obrigatória de' do
      it 'price' do
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
        )

        # Act
        result = offer.valid?

        # Assert
        expect(result).to eq false
      end
    end

    context 'após criar uma oferta' do
      it 'o campo active deve ser true' do
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
          price: 25
        )

        # Act
        offer.save!

        # Assert
        expect(offer.active).to eq true
      end

      it 'o campo start offer deve ter um valor' do
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
          price: 25
        )

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
          price: 25,
          active: false
        )

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
        beverage = Beverage.create!(
          name: 'Cachaça', 
          description: 'alcool delicioso baiano', 
          calories: '185', 
          establishment: establishment, 
          is_alcoholic: true
        )
        format = Format.create!(name: 'Bombinha 50ml')

        offer = Offer.new(
          format: format,
          item: beverage,
        )

        # Act
        result = offer.valid?

        # Assert
        expect(result).to eq false
      end
    end

    context 'após criar uma oferta' do
      it 'o campo active deve ser true' do
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
        beverage = Beverage.create!(
          name: 'Cachaça', 
          description: 'alcool delicioso baiano', 
          calories: '185', 
          establishment: establishment, 
          is_alcoholic: true
        )
        format = Format.create!(name: 'Bombinha 50ml')

        offer = Offer.create!(
          format: format,
          item: beverage,
          price: 25
        )

        # Act
        offer.save!

        # Assert
        expect(offer.active).to eq true
      end

      it 'o campo start offer deve ter um valor' do
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
        beverage = Beverage.create!(
          name: 'Cachaça', 
          description: 'alcool delicioso baiano', 
          calories: '185', 
          establishment: establishment, 
          is_alcoholic: true
        )
        format = Format.create!(name: 'Bombinha 50ml')

        offer = Offer.create!(
          format: format,
          item: beverage,
          price: 25
        )

        # Act
        offer.save!

        # Assert
        expect(offer.start_offer).not_to be_nil
      end
    end

    context 'após desativar uma oferta' do
      it 'o campo end_offer deve ser true' do
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
        beverage = Beverage.create!(
          name: 'Cachaça', 
          description: 'alcool delicioso baiano', 
          calories: '185', 
          establishment: establishment, 
          is_alcoholic: true
        )
        format = Format.create!(name: 'Bombinha 50ml')

        offer = Offer.create!(
          format: format,
          item: beverage,
          price: 25,
          active: false
        )

        # Act
        offer.save!

        # Assert
        expect(offer.end_offer).not_to be_nil
      end
    end
  end

end
