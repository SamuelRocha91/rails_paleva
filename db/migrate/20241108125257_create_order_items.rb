class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.references :offer, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.string :note

      t.timestamps
    end
  end
end
