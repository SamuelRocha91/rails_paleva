class OrderItem < ApplicationRecord
  belongs_to :offer
  belongs_to :order
end
