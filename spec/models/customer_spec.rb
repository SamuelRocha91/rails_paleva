require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'Validações' do
    it 'ausência de email e phone_number gera invalidade' do
      # Arrange
      customer = Customer.new(name: 'Samuel', cpf: CPF.generate)

      # Act
      result = customer.valid?

      # Assert
      expect(result).to eq false
    end

    it 'presença de email sem phone_number é válido' do
      # Arrange
      customer = Customer.new(name: 'Samuel', cpf: CPF.generate, email: 'samuel_s@gmail.com')

      # Act
      result = customer.valid?

      # Assert
      expect(result).to eq true
    end

    it 'presença de phone_number sem email é válido' do
      # Arrange
      customer = Customer.new(name: 'Samuel', cpf: CPF.generate, phone_number: '71992594946')

      # Act
      result = customer.valid?

      # Assert
      expect(result).to eq true
    end

    it 'caso presente, email deve ser válido' do
      # Arrange
      customer = Customer.new(name: 'Samuel', cpf: CPF.generate, email: 'samuel_s@gm', phone_number: '71992594946')

      # Act
      result = customer.valid?

      # Assert
      expect(result).to eq false
    end

    it 'caso presente, cpf deve ser válido' do
      # Arrange
      customer = Customer.new(name: 'Samuel', cpf: '00', email: 'samuel_s@gmail.com', phone_number: '71992594946')

      # Act
      result = customer.valid?

      # Assert
      expect(result).to eq false
    end

    it 'caso presente, phone_number deve ser válido' do
      # Arrange
      customer = Customer.new(name: 'Samuel', email: 'samuel_s@gmail.com', phone_number: '719925949')

      # Act
      result = customer.valid?

      # Assert
      expect(result).to eq false
    end
  end
end
