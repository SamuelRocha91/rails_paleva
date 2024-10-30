class Offer < ApplicationRecord
  belongs_to :format
  belongs_to :item, polymorphic: true
  validates :price, presence: true
end
