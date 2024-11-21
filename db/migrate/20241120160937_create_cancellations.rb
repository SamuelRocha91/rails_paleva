class CreateCancellations < ActiveRecord::Migration[7.1]
  def change
    create_table :cancellations do |t|
      t.references :order, null: false, foreign_key: true
      t.text :justification

      t.timestamps
    end
  end
end
