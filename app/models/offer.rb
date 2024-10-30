class Offer < ApplicationRecord
  belongs_to :format
  belongs_to :item, polymorphic: true
end
