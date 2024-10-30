require 'rails_helper'

RSpec.describe Format, type: :model do
  describe 'Validação de formato' do
    context 'Presença obrigatória de' do
      it 'name' do
        # Arrange
        format = Format.new
        # Act
        result = format.valid?
        # Assert
        expect(result).to eq false  
      end
    end
  end
end
