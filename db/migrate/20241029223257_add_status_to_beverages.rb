class AddStatusToBeverages < ActiveRecord::Migration[7.1]
  def change
    add_column :beverages, :status, :boolean, default: true
  end
end
