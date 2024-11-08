class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :establishment
  accepts_nested_attributes_for :customer
  has_many :order_items
  before_validation :generate_code, on: :create
  enum status: { pending_kitchen_confirmation: 0, in_preparation: 2, ready: 5, delivered: 7, canceled: 9 }

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8)
  end
end
