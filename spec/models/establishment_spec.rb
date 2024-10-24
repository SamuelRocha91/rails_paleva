require 'rails_helper'

RSpec.describe Establishment, type: :model do
  describe 'Validações' do
    context 'presença obrigatória de' do
      it 'email' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'', trade_name: 'Samsumg', legal_name: 'Samsumg LTDA', cnpj: '56924048000140', phone_number: '71992594946', address: 'Rua das Alamedas avenidas' )
        establishment.user = user
        # Act
        result = establishment.valid?
        # Assert
        expect(result).to eq false
      end

      it 'trade_name' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'sam@hotmail.com', trade_name: '', legal_name: 'Samsumg LTDA', cnpj: '56924048000140', phone_number: '71992594946', address: 'Rua das Alamedas avenidas' )
        establishment.user = user
        # Act
        result = establishment.valid?
        # Assert
        expect(result).to eq false
      end

      it 'legal_name' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'sam@hotmail.com', trade_name: 'Samsumg', legal_name: '', cnpj: '56924048000140', phone_number: '71992594946', address: 'Rua das Alamedas avenidas' )
        establishment.user = user
        # Act
        result = establishment.valid?
        # Assert
        expect(result).to eq false
      end

      it 'cnpj' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'sam@hotmail.com', trade_name: 'Samsumg', legal_name: 'Samsumg LTDA', cnpj: '', phone_number: '71992594946', address: 'Rua das Alamedas avenidas' )
        establishment.user = user
        # Act
        result = establishment.valid?
        # Assert
        expect(result).to eq false
      end

      it 'phone_number' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'sam@hotmail.com', trade_name: 'Samsumg', legal_name: 'Samsumg LTDA', cnpj: '56924048000140', phone_number: '', address: 'Rua das Alamedas avenidas' )
        establishment.user = user
        # Act
        result = establishment.valid?
        # Assert
        expect(result).to eq false
      end

      it 'address' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'sam@hotmail.com', trade_name: 'Samsumg', legal_name: 'Samsumg LTDA', cnpj: '56924048000140', phone_number: '71992594946', address: '' )
        establishment.user = user
        # Act
        result = establishment.valid?
        # Assert
        expect(result).to eq false
      end
    end

    context 'deve ser válido' do
      it 'cnpj' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'samsu@gmail.com', trade_name: 'Samsumg', legal_name: 'Samsumg LTDA', cnpj: '569240480140', phone_number: '71992594946', address: 'Rua das Alamedas avenidas' )
        establishment.user = user
        # Act
        result = establishment.valid?
        # Assert
        expect(result).to eq false   
      end

      it 'phone_number' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'samsu@gmail.com', trade_name: 'Samsumg', legal_name: 'Samsumg LTDA', cnpj: '56924048000140', phone_number: '71992594a46', address: 'Rua das Alamedas avenidas' )
        establishment.user = user
        # Act
        result = establishment.valid?
        # Assert
        expect(result).to eq false   
      end


      it 'email' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
        establishment = Establishment.new(email:'samsu@gmail', trade_name: 'Samsumg', legal_name: 'Samsumg LTDA', cnpj: '56924048000140', phone_number: '71992594946', address: 'Rua das Alamedas avenidas' )
        establishment.user = user
        # Act
        result = establishment.valid?
        # Assert
        expect(result).to eq false   
      end
    end
  end
end
