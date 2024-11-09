class UpdateUserAndEstablishmentRelationship < ActiveRecord::Migration[7.1]
  def change
    remove_column :establishments, :user_id, :bigint if column_exists?(:establishments, :user_id)

    add_reference :users, :establishment, foreign_key: true, index: true
  end
end
