class Offer < ApplicationRecord
  belongs_to :format
  belongs_to :item, polymorphic: true
  validates :price, presence: true
  before_validation :set_start_offer, on: :create
  before_validation :set_end_offer, on: :update

  private

  def set_start_offer
    self.start_offer = DateTime.now
  end

  def set_end_offer
    self.end_offer = DateTime.now
  end
end
