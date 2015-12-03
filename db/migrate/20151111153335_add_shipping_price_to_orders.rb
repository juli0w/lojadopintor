class AddShippingPriceToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_price, :decimal, :precision => 8, :scale => 2
  end
end
