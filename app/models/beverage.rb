class Beverage < ApplicationRecord
  belongs_to :establishment
  has_one_attached :image
  validates :name, :description, presence: true
  has_many :volumes, as: :item, class_name: 'Offer'
end
