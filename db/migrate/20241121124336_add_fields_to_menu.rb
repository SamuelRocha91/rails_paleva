class AddFieldsToMenu < ActiveRecord::Migration[7.1]
  def change
    add_column :menus, :valid_from, :date
    add_column :menus, :valid_until, :date
  end
end
