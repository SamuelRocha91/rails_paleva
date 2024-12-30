require 'rails_helper'

RSpec.describe TemporaryUser, type: :model do
  describe 'Validação' do
    it 'Email deve ser único na aplicação' do
      # Arrange
      establishment = create(:establishment)
      create(:user, email: 'samuel@hotmail.com', establishment: establishment)

      temporary_user = TemporaryUser.new(cpf: CPF.generate, email: 'samuel@hotmail.com', establishment: establishment)

      # Act
      result = temporary_user.valid?

      # Assert
      expect(result).to eq false
    end

    it 'Email deve ser válido' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      temporary_user = TemporaryUser.new(cpf: CPF.generate, email: 'samuelhotmailcom', establishment: establishment)

      # Act
      result = temporary_user.valid?

      # Assert
      expect(result).to eq false
    end

    it 'CPF deve ser único na aplicação' do
      # Arrange
      establishment = create(:establishment)
      create(:user, cpf: '22611819572', establishment: establishment)
      temporary_user = TemporaryUser.new(cpf: '22611819572', email: 'samul@hotmail.com', establishment: establishment)

      # Act
      result = temporary_user.valid?

      # Assert
      expect(result).to eq false
    end

    it 'CPF deve ser válido' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      temporary_user = TemporaryUser.new(cpf: '22611819', email: 'samul@hotmail.com', establishment: establishment)

      # Act
      result = temporary_user.valid?

      # Assert
      expect(result).to eq false
    end
  end
end
