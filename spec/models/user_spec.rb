require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Método description da model de usuário' do
    it 'exibe nome completo e email' do
      # Arrange
      user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com')
      # Act
      result = user.description
      # Assert
      expect(result).to eq 'Samuel Rocha - sam@hotmail.com'  
    end
  end

  describe 'Validações'
    context 'presença obrigatória de' do
      it 'email' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: '', password: '123456789101112', cpf: '03478599927')
        # Act
        result = user.valid?
        # Assert
        expect(result).to eq false
      end

      it 'first_name' do
        # Arrange
        user = User.new(first_name: '', last_name: 'Rocha', email: 'sam@hotmail.com', password: '123456789101112', cpf: '03478599927')
        # Act
        result = user.valid?
        # Assert
        expect(result).to eq false
      end

      it 'last_name' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: '', email: 'sam@hotmail.com', password: '123456789101112', cpf: '03478599927')
        # Act
        result = user.valid?
        # Assert
        expect(result).to eq false
      end

      it 'password' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com', password: '', cpf: '03478599927')
        # Act
        result = user.valid?
        # Assert
        expect(result).to eq false
      end

      it 'cpf' do
        # Arrange
        user = User.new(first_name: 'Samuel', last_name: 'Rocha', email: 'sam@hotmail.com', password: '123456789101112', cpf: '')
        # Act
        result = user.valid?
        # Assert
        expect(result).to eq false
      end
    
  end
  
end
