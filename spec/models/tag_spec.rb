require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'Validações' do
    context 'presença obrigatória de' do
      it 'name' do
        # Arrange
        tag = Tag.new

        # Act
        result = tag.valid?

        # Assert
        expect(result).to eq false
      end
    end
    context 'unicidade de campo' do
      it 'name' do
        # Arrange
        Tag.create!(name: 'Apimentado')
        format = Tag.new(name: 'Apimentado')

        # Act
        result = format.valid?

        # Assert
        expect(result).to eq false
      end

      it 'que é case insensitive' do
        # Arrange
        Tag.create!(name: 'Apimentado')
        tag = Tag.new(name: 'ApimeNTAdo')

        # Act
        result = tag.valid?

        # Assert
        expect(result).to eq false
      end
    end

    context 'mínimo de caracteres' do
      it 'para name são 3' do
        # Arrange
        format = Tag.new(name: 'Ap')

        # Act
        result = format.valid?

        # Assert
        expect(result).to eq false
      end
    end
  end
end
