class Dish < ApplicationRecord
  belongs_to :establishment
  has_one_attached :image
end
