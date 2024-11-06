class MenuItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item, polymorphic: true
end
