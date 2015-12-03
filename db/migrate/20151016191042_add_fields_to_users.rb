class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :cellphone, :string
    add_column :users, :address, :string
    add_column :users, :uf, :string
    add_column :users, :city, :string
    add_column :users, :cep, :string
  end
end
