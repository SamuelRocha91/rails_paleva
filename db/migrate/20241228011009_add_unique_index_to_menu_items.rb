class AddUniqueIndexToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_index :menu_items, [:item_id, :menu_id, :item_type], unique: true, name: 'index_menu_items_on_item_id_and_menu_id_and_item_type'
  end
end
