class AddEstablishmentToOrder < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :establishment, null: false, foreign_key: true
  end
end
