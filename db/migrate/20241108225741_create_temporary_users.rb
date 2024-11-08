class CreateTemporaryUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :temporary_users do |t|
      t.string :email
      t.string :cpf
      t.references :establishment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
