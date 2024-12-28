class Offer < ApplicationRecord
  belongs_to :format
  belongs_to :item, polymorphic: true
  before_validation :set_start_offer, on: :create
  before_validation :set_end_offer
  validate :valid_price?
  validates :price, presence: true

  private

  def set_start_offer
    self.start_offer = DateTime.now
  end

  def set_end_offer
    return unless active == false

    self.end_offer = DateTime.now
  end

  def valid_price?
    price = self.price.to_f
    return unless self.price.present? && (price < 1)

    errors.add :price,
               ' não pode ficar em branco e deve ser maior que R$ 1,00'
  end
end
