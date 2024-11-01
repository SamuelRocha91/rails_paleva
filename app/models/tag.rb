class Tag < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3}
  validates :name, uniqueness: { case_sensitive: false }

end
