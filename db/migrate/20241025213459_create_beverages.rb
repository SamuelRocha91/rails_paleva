class CreateBeverages < ActiveRecord::Migration[7.1]
  def change
    create_table :beverages do |t|
      t.string :name
      t.string :description
      t.boolean :is_alcoholic
      t.string :calories
      t.references :establishment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
