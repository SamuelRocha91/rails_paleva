class Tag < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

end
