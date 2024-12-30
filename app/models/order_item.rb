class OrderItem < ApplicationRecord
  belongs_to :offer
  belongs_to :order
  validate :offer_has_menu

  private

  def offer_has_menu
    return unless offer.item.menu_items.empty?

    errors.add :offer, ' deve estar vinculada a um menu'
  end
end
