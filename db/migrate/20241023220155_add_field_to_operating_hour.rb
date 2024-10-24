class AddFieldToOperatingHour < ActiveRecord::Migration[7.1]
  def change
    add_column :operating_hours, :is_closed, :boolean
  end
end
