class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :establishment
  accepts_nested_attributes_for :customer
  has_many :order_items
  has_one :cancellation
  before_validation :generate_code, on: :create
  enum status: { 
    pending_kitchen_confirmation: 0,
    in_preparation: 2, 
    ready: 5, 
    delivered: 7, 
    canceled: 9 
  }
  validate :check_status_change, on: :update
  validate :set_datetime, on: :update

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8)
  end

  def check_status_change
    if status_changed? 
      previous_status = status_was
      new_status = status

      case previous_status
      when 'pending_kitchen_confirmation'
        check_status_pending new_status, previous_status
      when 'in_preparation'
        check_status_preparation new_status, previous_status
      when 'ready'
        check_status_ready new_status, previous_status
      when 'delivered'
        self.status = previous_status
        self.errors.add :status, " não pode ser alterado"
      when 'canceled'
        self.status = previous_status
        self.errors.add :status, " não pode ser alterado"
      end

    end
  end

  def check_status_pending(status, previous_status)
    if status != 'in_preparation' && status != 'canceled'
      self.status = previous_status
       self.errors.add :status, " deve ser um valor válido"
    end
  end

  def check_status_preparation(status, previous_status)
    if status != 'ready' && status != 'canceled'
      self.status = previous_status 
      self.errors.add :status, " deve ser um valor válido"
    end
  end

  def check_status_ready(status, previous_status)
    if status != 'delivered' && status != 'canceled'
      self.status = previous_status 
      self.errors.add :status, " deve ser um valor válido"
    end
  end

  def set_datetime
    if self.status == 'in_preparation'
      self.accepted_at = DateTime.current
    elsif self.status == 'ready'
      self.completed_at = DateTime.current
    elsif self.status == 'delivered'
      self.delivered_at = DateTime.current
    end
  end
end
