require 'rails_helper'

RSpec.describe User, type: :model do
  random_cpf = CPF.generate.to_s
  describe 'Método description da model de usuário' do
    it 'exibe nome completo e email' do
      # Arrange
      user = User.new(
        first_name: 'Samuel',
        last_name: 'Rocha',
        email: 'sam@hotmail.com'
      )

      # Act
      result = user.description

      # Assert
      expect(result).to eq 'Samuel Rocha - sam@hotmail.com'
    end
  end

  describe 'Validações' do
    context 'presença obrigatória de' do
      it 'email' do
        # Arrange
        user = User.new(
          first_name: 'Samuel',
          last_name: 'Rocha',
          email: '',
          password: '123456789101112',
          cpf: random_cpf
        )

        # Act
        result = user.valid?

        # Assert
        expect(result).to eq false
      end

      it 'first_name' do
        # Arrange
        user = User.new(
          first_name: '',
          last_name: 'Rocha',
          email: 'sam@hotmail.com',
          password: '123456789101112',
          cpf: random_cpf
        )

        # Act
        result = user.valid?

        # Assert
        expect(result).to eq false
      end

      it 'last_name' do
        # Arrange
        user = User.new(
          first_name: 'Samuel',
          last_name: '',
          email: 'sam@hotmail.com',
          password: '123456789101112',
          cpf: random_cpf
        )

        # Act
        result = user.valid?

        # Assert
        expect(result).to eq false
      end

      it 'password' do
        # Arrange
        user = User.new(
          first_name: 'Samuel',
          last_name: 'Rocha',
          email: 'sam@hotmail.com',
          password: '',
          cpf: random_cpf
        )

        # Act
        result = user.valid?

        # Assert
        expect(result).to eq false
      end

      it 'cpf' do
        # Arrange
        user = User.new(
          first_name: 'Samuel',
          last_name: 'Rocha',
          email: 'sam@hotmail.com',
          password: '123456789101112',
          cpf: ''
        )

        # Act
        result = user.valid?

        # Assert
        expect(result).to eq false
      end
    end

    context 'Campo deve ter registro único' do
      it 'cpf' do
        # Arrange
        random_cpf = CPF.generate.to_s
        User.create!(
          first_name: 'Samuel',
          last_name: 'Rocha',
          email: 'sam@hotmail.com',
          password: '123456789101112',
          cpf: '22611819572'
        )
        user_two = User.new(
          first_name: 'Robson',
          last_name: 'Rocha',
          email: 'rob@hotmail.com',
          password: '123456789101112',
          cpf: '22611819572'
        )

        # Act
        result = user_two.valid?

        # Assert
        expect(result).to eq false
      end

      it 'email' do
        # Arrange
        User.create!(
          first_name: 'Samuel',
          last_name: 'Rocha',
          email: 'sam@hotmail.com',
          password: '123456789101112',
          cpf: '22611819572'
        )
        user_two = User.new(
          first_name: 'Robson',
          last_name: 'Rocha',
          email: 'sam@hotmail.com',
          password: '123456129101112',
          cpf: CPF.generate.to_s
        )

        # Act
        result = user_two.valid?

        # Assert
        expect(result).to eq false
      end
    end

    context 'Campo deve ter comprimento adequado' do
      it 'cpf' do
        # Arrange
        user = User.new(
          first_name: 'Robson',
          last_name: 'Rocha',
          email: 'rob@hotmail.com',
          password: '123456789101112',
          cpf: '0348859995'
        )

        # Act
        result = user.valid?

        # Assert
        expect(result).to eq false
      end

      it 'password' do
        # Arrange
        user = User.new(
          first_name: 'Samuel',
          last_name: 'Rocha',
          email: 'sam@hotmail.com',
          password: '12345671011',
          cpf: CPF.generate.to_s
        )

        # Act
        result = user.valid?

        # Assert
        expect(result).to eq false
      end
    end

    context 'deve ser válido' do
      it 'cpf' do
        # Arrange
        user = User.new(
          first_name: 'Samuel',
          last_name: 'Rocha',
          email: 'sam@hotmail.com',
          password: '12345671011',
          cpf: '034667985AZ'
        )

        # Act
        result = user.valid?

        # Assert
        expect(result).to eq false
      end
    end
  end
end
