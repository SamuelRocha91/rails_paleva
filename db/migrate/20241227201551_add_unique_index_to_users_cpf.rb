class AddUniqueIndexToUsersCpf < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :cpf, unique: true
  end
end
