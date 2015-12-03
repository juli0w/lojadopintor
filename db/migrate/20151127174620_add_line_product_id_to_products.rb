class AddLineProductIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :line_product_id, :integer
  end
end
