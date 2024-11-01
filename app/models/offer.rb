class Offer < ApplicationRecord
  belongs_to :format
  belongs_to :item, polymorphic: true
  before_validation :set_start_offer, on: :create
  before_validation :set_end_offer, on: :update
  validate :is_valid_price?
  validates :price, presence: true

  private

  def set_start_offer
    self.start_offer = DateTime.now
  end

  def set_end_offer
    self.end_offer = DateTime.now
  end

  def is_valid_price?
    price = self.price.to_f
    if self.price.present? && (price < 1)
      self.errors.add :price, " não pode ficar em branco e deve ser maior que R$ 1,00"
    end
  end
end
