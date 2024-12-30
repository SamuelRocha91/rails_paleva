class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :establishment
  accepts_nested_attributes_for :customer
  has_many :order_items, dependent: :nullify
  has_one :cancellation, dependent: :nullify
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
    return unless status_changed?

    case status_was
    when 'pending_kitchen_confirmation' then check_status_pending status, status_was
    when 'in_preparation' then check_status_preparation status, status_was
    when 'ready' then check_status_ready status, status_was
    when 'delivered', 'canceled'
      self.status = status_was
      errors.add :status, ' não pode ser alterado'
    end
  end

  def check_status_pending(status, previous_status)
    return unless status != 'in_preparation' && status != 'canceled'

    self.status = previous_status
    errors.add :status, ' deve ser um valor válido'
  end

  def check_status_preparation(status, previous_status)
    return unless status != 'ready' && status != 'canceled'

    self.status = previous_status
    errors.add :status, ' deve ser um valor válido'
  end

  def check_status_ready(status, previous_status)
    return unless status != 'delivered' && status != 'canceled'

    self.status = previous_status
    errors.add :status, ' deve ser um valor válido'
  end

  def set_datetime
    case status
    when 'in_preparation'
      self.accepted_at = DateTime.current
    when 'ready'
      self.completed_at = DateTime.current
    when 'delivered'
      self.delivered_at = DateTime.current
    end
  end
end
