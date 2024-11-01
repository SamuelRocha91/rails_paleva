class ChangeActiveDefaultInOffers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :offers, :active, from: nil, to: true
  end
end
