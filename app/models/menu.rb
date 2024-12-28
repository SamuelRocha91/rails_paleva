class Menu < ApplicationRecord
  has_many :menu_items, dependent: :destroy
  belongs_to :establishment
  has_many :dishes, through: :menu_items, source: :item, source_type: 'Dish'
  has_many :beverages, through: :menu_items, source: :item, source_type: 'Beverage'
  validates :name, presence: true, length: { minimum: 3 }
  validates :name, uniqueness: { scope: :establishment_id }
  validate :valid_seasonal_dates
  validate :valid_order_dates

  private

  def valid_seasonal_dates
    if valid_from && !valid_until
      errors.add :valid_until,
                 ' deve estar presente no cadastro de pratos sazonais'
    elsif !valid_from && valid_until
      errors.add :valid_from,
                 ' deve estar presente no cadastro de pratos sazonais'
    end
  end

  def valid_order_dates
    return unless valid_from && valid_until && valid_from >= valid_until

    errors.add :valid_from,
               ' deve estar ser menor que a data de fim da validade'
  end
end
