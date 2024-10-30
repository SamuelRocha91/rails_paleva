class Offer < ApplicationRecord
  belongs_to :format
  belongs_to :item, polymorphic: true
  validates :price, presence: true
  before_validation :set_active_and_start_offer, on: create

  private

  def set_active_and_start_offer
    self.start_offer = DateTime.now
  end
end
