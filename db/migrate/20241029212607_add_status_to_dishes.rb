class AddStatusToDishes < ActiveRecord::Migration[7.1]
  def change
    add_column :dishes, :status, :boolean, default: true
  end
end
