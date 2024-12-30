class AddUniqueIndexToMenusName < ActiveRecord::Migration[7.1]
  def change
    add_index :menus, :name, unique: true
  end
end
