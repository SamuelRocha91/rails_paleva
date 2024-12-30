require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Após criar um pedido' do
    it 'Deve ser setado com status correto' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.new(establishment: establishment, customer: customer)

      # Act
      order.save

      # Assert
      expect(order.status).to eq 'pending_kitchen_confirmation'
    end

    it 'status pending_kitchen_confirmation não pode ser alterado pra ready' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer)

      # Act
      order.status = 'ready'
      order.save

      # Assert
      expect(order.status).to eq 'pending_kitchen_confirmation'
      expect(order.errors[:status]).to include(' deve ser um valor válido')
    end

    it 'status pending_kitchen_confirmation não pode ser alterado pra delivered' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer)

      # Act
      order.status = 'delivered'
      order.save

      # Assert
      expect(order.status).to eq 'pending_kitchen_confirmation'
      expect(order.errors[:status]).to include(' deve ser um valor válido')
    end

    it 'status in_preparation não pode ser alterado pra pending_kitchen_confirmation' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 2)

      # Act
      order.status = 'delivered'
      order.save

      # Assert
      expect(order.status).to eq 'in_preparation'
      expect(order.errors[:status]).to include(' deve ser um valor válido')
    end

    it 'status in_preparation não pode ser alterado pra ready' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 2)

      # Act
      order.status = 'delivered'
      order.save

      # Assert
      expect(order.status).to eq 'in_preparation'
      expect(order.errors[:status]).to include(' deve ser um valor válido')
    end

    it 'status ready não pode ser alterado pra pending_kitchen_confirmation' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 5)

      # Act
      order.status = 'pending_kitchen_confirmation'
      order.save

      # Assert
      expect(order.status).to eq 'ready'
      expect(order.errors[:status]).to include(' deve ser um valor válido')
    end

    it 'status ready não pode ser alterado pra in_preparation' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 5)

      # Act
      order.status = 'in_preparation'
      order.save

      # Assert
      expect(order.status).to eq 'ready'
      expect(order.errors[:status]).to include(' deve ser um valor válido')
    end

    it 'status delivered não pode ser alterado pra pending_kitchen_confirmation' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 7)

      # Act
      order.status = 'pending_kitchen_confirmation'
      order.save

      # Assert
      expect(order.status).to eq 'delivered'
      expect(order.errors[:status]).to include(' não pode ser alterado')
    end

    it 'status delivered não pode ser alterado pra in_preparation' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 7)

      # Act
      order.status = 'in_preparation'
      order.save

      # Assert
      expect(order.status).to eq 'delivered'
      expect(order.errors[:status]).to include(' não pode ser alterado')
    end

    it 'status delivered não pode ser alterado pra ready' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 7)

      # Act
      order.status = 'ready'
      order.save

      # Assert
      expect(order.status).to eq 'delivered'
      expect(order.errors[:status]).to include(' não pode ser alterado')
    end

    it 'status delivered não pode ser alterado pra canceled' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 7)

      # Act
      order.status = 'canceled'
      order.save

      # Assert
      expect(order.status).to eq 'delivered'
      expect(order.errors[:status]).to include(' não pode ser alterado')
    end

    it 'status canceled não pode ser alterado pra pending_kitchen_confirmation' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 9)

      # Act
      order.status = 'pending_kitchen_confirmation'
      order.save

      # Assert
      expect(order.status).to eq 'canceled'
      expect(order.errors[:status]).to include(' não pode ser alterado')
    end

    it 'status canceled não pode ser alterado pra in_preparation' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 9)

      # Act
      order.status = 'in_preparation'
      order.save

      # Assert
      expect(order.status).to eq 'canceled'
      expect(order.errors[:status]).to include(' não pode ser alterado')
    end

    it 'status canceled não pode ser alterado pra ready' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 9)

      # Act
      order.status = 'ready'
      order.save

      # Assert
      expect(order.status).to eq 'canceled'
      expect(order.errors[:status]).to include(' não pode ser alterado')
    end

    it 'status canceled não pode ser alterado pra delivered' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer, status: 9)

      # Act
      order.status = 'delivered'
      order.save

      # Assert
      expect(order.status).to eq 'canceled'
      expect(order.errors[:status]).to include(' não pode ser alterado')
    end

    it 'Deve gerar código alfanumérico' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.new(establishment: establishment, customer: customer)

      # Act
      order.save

      # Assert
      expect(order.code.length).to eq 8
    end

    it 'Código alfanumérico não é atualizado com atualização de pedido' do
      # Arrange
      establishment = create(:establishment)
      create(:user, establishment: establishment)
      customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
      order = Order.create!(establishment: establishment, customer: customer)
      initial_code = order.code

      # Act
      order.in_preparation!

      # Assert
      expect(initial_code).to eq order.code
    end
  end

  context 'atualização de status' do
    describe 'gera preenchimento de campo datetime' do
      it 'accepted_at quando o status muda pra in_preparation' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
        order = Order.create!(establishment: establishment, customer: customer)

        # Act
        order.in_preparation!

        # Assert
        expect(order.accepted_at.strftime('%d-%m-%Y')).to eq DateTime.current.strftime('%d-%m-%Y')
      end

      it 'completed_at quando o status muda pra ready' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
        order = Order.create!(establishment: establishment, customer: customer)

        # Act
        order.in_preparation!
        order.ready!

        # Assert
        expect(
          order.completed_at.strftime('%d-%m-%Y')
        ).to eq DateTime.current.strftime('%d-%m-%Y')
      end

      it 'delivered_at quando o status muda pra delivered' do
        # Arrange
        establishment = create(:establishment)
        create(:user, establishment: establishment)
        customer = Customer.create!(name: 'Samuel', email: 'sam@gmail.com')
        order = Order.create!(establishment: establishment, customer: customer)

        # Act
        order.in_preparation!
        order.ready!
        order.delivered!

        # Assert
        expect(order.delivered_at.strftime('%d-%m-%Y')).to eq DateTime.current.strftime('%d-%m-%Y')
      end
    end
  end
end
