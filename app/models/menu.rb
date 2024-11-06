class Menu < ApplicationRecord
  has_many :menu_items, dependent: :destroy
  belongs_to :establishment
  has_many :dishes, through: :menu_items, source: :item, source_type: 'Dish' 
  has_many :beverages, through: :menu_items, source: :item, source_type: 'Beverage'

  validates :name, presence: true, length: { minimum: 3}
end
