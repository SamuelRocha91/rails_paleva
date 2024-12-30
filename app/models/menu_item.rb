class MenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item, polymorphic: true
  validates :item_id, uniqueness: { scope: %i[menu_id item_type] }
end
