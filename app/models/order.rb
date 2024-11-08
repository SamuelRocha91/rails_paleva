class Order < ApplicationRecord
  belongs_to :customer
  accepts_nested_attributes_for :customer
  has_many :order_items
end
