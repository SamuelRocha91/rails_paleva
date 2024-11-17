require 'rails_helper'

RSpec.describe Menu, type: :model do
  context 'Validações' do
    it 'Presença obrigatória de #name' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )
      menu = Menu.new(establishment: establishment, name: '')

      # Act
      result = menu.valid?

      # Assert
      expect(result).to eq false
    end

    it '#name deve ter ao menos três caracteres' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )

      menu = Menu.new(establishment: establishment, name: 'Ab')

      # Act
      result = menu.valid?

      # Assert
      expect(result).to eq false
    end

    it '#name deve ser único para dado restaurante' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )

      Menu.create!(
        establishment: establishment, 
        name: 'Café da manhã'
      )
      menu_two = Menu.new(
        establishment: establishment, 
        name: 'Café da manhã'
      )
  
      # Act
      result = menu_two.valid?

      # Assert
      expect(result).to eq false
    end

    it '#name pode ser repetido por usuários diferentes' do
      # Arrange
      establishment = Establishment.create!(
        email: 'sam@gmail.com', 
        trade_name: 'Samsung', 
        legal_name: 'Samsung LTDA', 
        cnpj: '56924048000140',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )
      User.create!(
        first_name: 'Samuel', 
        last_name: 'Rocha', 
        email: 'samuel@hotmail.com', 
        password: '12345678910111',  
        cpf: '22611819572',
        establishment: establishment
      )

      establishment_two = Establishment.create!(
        email: 'dam@gmail.com', 
        trade_name: 'Apple', 
        legal_name: 'Apple LTDA', 
        cnpj: '19047952000199',
        phone_number: '71992594946', 
        address: 'Rua das Alamedas avenidas',
      )

      User.create!(
        first_name: 'Daniela', 
        last_name: 'Rocha', 
        email: 'dani@hotmail.com', 
        password: '12345678910111',  
        cpf: CPF.generate,
        establishment: establishment_two
      )


      Menu.create!(
        establishment: establishment, 
        name: 'Café da manhã'
      )
      menu_two = Menu.new(
        establishment: establishment_two, 
        name: 'Café da manhã'
      )

      # Act
      result = menu_two.valid?

      # Assert
      expect(result).to eq true
    end
  end
end
