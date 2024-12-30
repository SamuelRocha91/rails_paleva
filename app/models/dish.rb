class Dish < ApplicationRecord
  belongs_to :establishment
  has_one_attached :image
  validates :name, :description, presence: true
  has_many :portions, as: :item, class_name: 'Offer', dependent: :destroy
  has_many :menus, through: :menu_items, dependent: :nullify
  has_many :menu_items, as: :item, dependent: :nullify
  has_many :dish_tags, dependent: :delete_all
  has_many :tags, through: :dish_tags
end
