class AddFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :customer_name, :string
    add_column :orders, :customer_phone, :string
    add_column :orders, :customer_cellphone, :string
    add_column :orders, :shipping_address, :string
    add_column :orders, :shipping_uf, :string
    add_column :orders, :shipping_city, :string
    add_column :orders, :shipping_cep, :string
  end
end
