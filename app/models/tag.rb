class Tag < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3 }
  validates :name, uniqueness: { case_sensitive: false }
  has_many :dish_tags, dependent: :delete_all
  has_many :dishes, through: :dish_tags
end
