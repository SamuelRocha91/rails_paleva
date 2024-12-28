class AddUniqueIndexToTemporaryUsersCpf < ActiveRecord::Migration[7.1]
  def change
    add_index :temporary_users, :cpf, unique: true
  end
end
