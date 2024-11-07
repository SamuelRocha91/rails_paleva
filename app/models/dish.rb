class Dish < ApplicationRecord
  belongs_to :establishment
  has_one_attached :image
  validates :name, :description, presence: true
  has_many :portions, as: :item, class_name: 'Offer'
  has_many :menus, through: :menu_items
  has_many :menu_items, as: :item
  has_many :dish_tags
  has_many :tags, through: :dish_tags
end
