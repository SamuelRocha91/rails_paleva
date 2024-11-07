require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'Validações' do
    it 'ausência de email e phone_number gera invalidade' do
      # Arrange
      customer = Customer.new(name: 'Samuel', cpf: CPF.generate )

      # Act
      result = customer.valid?

      # Assert
      expect(result).to eq false
    end

    it 'presença de email sem phone_number é válido' do
      # Arrange
      customer = Customer.new(name: 'Samuel', cpf: CPF.generate, email: 'samuel_s@gmail.com' )

      # Act
      result = customer.valid?

      # Assert
      expect(result).to eq true
    end

    it 'presença de phone_number sem email é válido' do
      # Arrange
      customer = Customer.new(name: 'Samuel', cpf: CPF.generate, phone_number: '71992594946' )

      # Act
      result = customer.valid?

      # Assert
      expect(result).to eq true
    end
  end
end
