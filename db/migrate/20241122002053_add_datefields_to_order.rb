class AddDatefieldsToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :accepted_at, :datetime
    add_column :orders, :completed_at, :datetime
    add_column :orders, :delivered_at, :datetime
  end
end
