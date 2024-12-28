class AddUniqueIndexToFormat < ActiveRecord::Migration[7.1]
  def change
    add_index :formats, :name, unique: true
  end
end
