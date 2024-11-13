class DropEmployeesTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :employees
  end
end
