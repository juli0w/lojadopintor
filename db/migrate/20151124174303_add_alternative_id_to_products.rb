class AddAlternativeIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :alternative_id, :integer
  end
end
