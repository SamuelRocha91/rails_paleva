class Establishment < ApplicationRecord
  validates :trade_name, :legal_name, :cnpj, :address,
             :phone_number, :email, presence: true
  belongs_to :user
  has_many :operating_hours
  accepts_nested_attributes_for :operating_hours

  
end
