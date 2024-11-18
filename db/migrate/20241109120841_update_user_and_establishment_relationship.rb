class UpdateUserAndEstablishmentRelationship < ActiveRecord::Migration[7.1]
  def change
    remove_column :establishments, :user_id, :bigint if column_exists?(:establishments, :user_id)

  end
end