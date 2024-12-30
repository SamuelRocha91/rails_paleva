class AddUniqueIndexToMenus < ActiveRecord::Migration[6.0]
  def change
    remove_index :menus, :name
    add_index :menus, [:name, :establishment_id], unique: true, name: 'index_menus_on_name_and_establishment_id'
  end
end

