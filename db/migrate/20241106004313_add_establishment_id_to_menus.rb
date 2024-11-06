class AddEstablishmentIdToMenus < ActiveRecord::Migration[7.1]
  def change
    add_reference :menus, :establishment, foreign_key: true
  end
end