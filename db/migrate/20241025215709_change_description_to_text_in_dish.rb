class ChangeDescriptionToTextInDish < ActiveRecord::Migration[7.1]
  def change
    change_column :dishes, :description, :text
  end
end
