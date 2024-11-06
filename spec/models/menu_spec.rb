require 'rails_helper'

RSpec.describe Menu, type: :model do
  context 'Validações' do
    it 'Presença pbrigatória de #name' do
      # Arrange
      user = User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572'
      )

      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
        user: user
      )

      menu = Menu.new(establishment: establishment, name: '')

      # Act
      result = menu.valid?

      # Assert
      expect(result).to eq false
    end

    it '#name deve ter ao menos três caracteres' do
      # Arrange
      user = User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572'
      )

      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
        user: user
      )

      menu = Menu.new(establishment: establishment, name: 'Ab')

      # Act
      result = menu.valid?

      # Assert
      expect(result).to eq false
    end
  end
end
