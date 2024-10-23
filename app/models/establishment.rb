class Establishment < ApplicationRecord
  belongs_to :user
  has_many :operating_hours
  accepts_nested_attributes_for :operating_hours
end
