class CreateOperatingHours < ActiveRecord::Migration[7.1]
  def change
    create_table :operating_hours do |t|
      t.integer :week_day
      t.time :start_time
      t.time :end_time
      t.references :establishment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
