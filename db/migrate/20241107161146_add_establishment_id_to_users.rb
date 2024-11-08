class AddEstablishmentIdToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :establishment_id, :integer
    add_foreign_key :users, :establishments, column: :establishment_id
  end
end