class ChangeDescriptionToTextInBeverages < ActiveRecord::Migration[7.1]
  def change
    change_column :beverages, :description, :text
  end
end
