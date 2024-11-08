class AddFieldsToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :status, :integer, default: 0
    add_column :orders, :code, :string
  end
end
