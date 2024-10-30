class CreateOffers < ActiveRecord::Migration[7.1]
  def change
    create_table :offers do |t|
      t.references :format, null: false, foreign_key: true
      t.references :item, polymorphic: true, null: false
      t.datetime :start_offer
      t.datetime :end_offer
      t.boolean :active
      t.text :details
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
