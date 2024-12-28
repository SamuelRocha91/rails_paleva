require 'rails_helper'

RSpec.describe TemporaryUser, type: :model do
  describe 'Validação' do
    it 'Email deve ser único na aplicação' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )

      temporary_user = TemporaryUser.new(
        cpf: CPF.generate,
        email: 'samuel@hotmail.com',
        establishment: establishment
      )

      # Act
      result = temporary_user.valid?

      # Assert
      expect(result).to eq false
    end

    it 'Email deve ser válido' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )

      temporary_user = TemporaryUser.new(
        cpf: CPF.generate,
        email: 'samuelhotmailcom',
        establishment: establishment
      )

      # Act
      result = temporary_user.valid?

      # Assert
      expect(result).to eq false
    end

    it 'CPF deve ser único na aplicação' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )

      temporary_user = TemporaryUser.new(
        cpf: '22611819572',
        email: 'samul@hotmail.com',
        establishment: establishment
      )

      # Act
      result = temporary_user.valid?

      # Assert
      expect(result).to eq false
    end

    it 'CPF deve ser válido' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com',
        trade_name: 'Samsung',
        legal_name: 'Samsung LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      User.create!(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'samuel@hotmail.com',
        password: '12345678910111',
        cpf: '22611819572',
        establishment: establishment
      )

      temporary_user = TemporaryUser.new(
        cpf: '22611819',
        email: 'samul@hotmail.com',
        establishment: establishment
      )

      # Act
      result = temporary_user.valid?

      # Assert
      expect(result).to eq false
    end
  end
end
