require 'rails_helper'

RSpec.describe Establishment, type: :model do
  describe 'Validações' do
    context 'presença obrigatória de' do
      it 'email' do
        # Arrange
        establishment = Establishment.new(
          email: '',
          trade_name: 'Samsumg',
          legal_name: 'Samsumg LTDA',
          cnpj: '56924048000140',
          phone_number: '71992594946',
          address: 'Rua das Alamedas avenidas'
        )

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to eq false
      end

      it 'trade_name' do
        # Arrange
        establishment = Establishment.new(
          email: 'sam@hotmail.com',
          trade_name: '',
          legal_name: 'Samsumg LTDA',
          cnpj: '56924048000140',
          phone_number: '71992594946',
          address: 'Rua das Alamedas avenidas'
        )
        # Act
        result = establishment.valid?

        # Assert
        expect(result).to eq false
      end

      it 'legal_name' do
        # Arrange
        establishment = Establishment.new(
          email: 'sam@hotmail.com',
          trade_name: 'Samsumg',
          legal_name: '',
          cnpj: '56924048000140',
          phone_number: '71992594946',
          address: 'Rua das Alamedas avenidas'
        )

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to eq false
      end

      it 'cnpj' do
        # Arrange
        establishment = Establishment.new(
          email: 'sam@hotmail.com',
          trade_name: 'Samsumg',
          legal_name: 'Samsumg LTDA',
          cnpj: '',
          phone_number: '71992594946',
          address: 'Rua das Alamedas avenidas'
        )

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to eq false
      end

      it 'phone_number' do
        # Arrange
        establishment = Establishment.new(
          email: 'sam@hotmail.com',
          trade_name: 'Samsumg',
          legal_name: 'Samsumg LTDA',
          cnpj: '56924048000140',
          phone_number: '',
          address: 'Rua das Alamedas avenidas'
        )

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to eq false
      end

      it 'address' do
        # Arrange
        establishment = Establishment.new(
          email: 'sam@hotmail.com',
          trade_name: 'Samsumg',
          legal_name: 'Samsumg LTDA',
          cnpj: '56924048000140',
          phone_number: '71992594946',
          address: ''
        )

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to eq false
      end
    end

    context 'deve ser válido' do
      it 'cnpj' do
        # Arrange
        establishment = Establishment.new(
          email: 'samsu@gmail.com',
          trade_name: 'Samsumg',
          legal_name: 'Samsumg LTDA',
          cnpj: '569240480140',
          phone_number: '71992594946',
          address: 'Rua das Alamedas avenidas'
        )

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to eq false
      end

      it 'phone_number' do
        # Arrange
        establishment = Establishment.new(
          email: 'samsu@gmail.com',
          trade_name: 'Samsumg',
          legal_name: 'Samsumg LTDA',
          cnpj: '56924048000140',
          phone_number: '71992594a4',
          address: 'Rua das Alamedas avenidas'
        )

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to eq false
      end

      it 'email' do
        # Arrange
        establishment = Establishment.new(
          email: 'samsu@gmail',
          trade_name: 'Samsumg',
          legal_name: 'Samsumg LTDA',
          cnpj: '56924048000140',
          phone_number: '71992594946',
          address: 'Rua das Alamedas avenidas'
        )

        # Act
        result = establishment.valid?

        # Assert
        expect(result).to eq false
      end
    end
  end

  describe 'gera um código aleatório' do
    it 'ao criar um novo estabelecimento' do
      # Arrange
      establishment = Establishment.new(
        email: 'sam@gmail.com',
        trade_name: 'Samsumg',
        legal_name: 'Samsumg LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      operating_hour = []
      7.times do |i|
        operating_hour << OperatingHour
                          .new(week_day: i, is_closed: true)
      end
      establishment.operating_hours = operating_hour

      # Act
      establishment.save

      # Assert
      expect(establishment.code).not_to be_empty
      expect(establishment.code.length).to eq 6
    end

    it 'e o código é único' do
      # Arrange
      establishment = Establishment.new(
        email: 'sam@gmail.com',
        trade_name: 'Samsumg',
        legal_name: 'Samsumg LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )

      establishment_two = Establishment.new(
        email: 'samsdsdsds@gmail.com',
        trade_name: 'LG RANGOS',
        legal_name: 'La ra LTSA',
        cnpj: '51573271000177',
        phone_number: '71992194946',
        address: 'Rua das Alamedas  d dsdavenidas'
      )

      operating_hour = []
      operating_hour_two = []

      7.times do |i|
        operating_hour << OperatingHour
                          .new(week_day: i, is_closed: true)
      end
      7.times do |i|
        operating_hour_two << OperatingHour
                              .new(week_day: i, is_closed: true)
      end

      establishment.operating_hours = operating_hour
      establishment_two.operating_hours = operating_hour_two

      # Act
      establishment.save
      establishment_two.save

      # Assert
      expect(establishment.code).not_to eq establishment_two.code
    end

    it 'e não muda com atualização do estabelecimento' do
      # Arrange
      establishment = Establishment.new(
        email: 'sam@gmail.com',
        trade_name: 'Samsumg',
        legal_name: 'Samsumg LTDA',
        cnpj: '56924048000140',
        phone_number: '71992594946',
        address: 'Rua das Alamedas avenidas'
      )
      operating_hour = []
      7.times do |i|
        operating_hour << OperatingHour
                          .new(week_day: i, is_closed: true)
      end

      establishment.operating_hours = operating_hour
      establishment.save
      original_code = establishment.code

      # Act
      establishment.update!(phone_number: '85992588546')

      # Assert
      expect(establishment.code).to eq original_code
    end
  end
end
