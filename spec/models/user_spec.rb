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
  context 'presence' do
    
  end
  
end
