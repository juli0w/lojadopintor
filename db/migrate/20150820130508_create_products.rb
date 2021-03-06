class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price, precision: 12, scale: 3
      t.boolean :active
      t.text :description
      t.string :excerpt
      t.decimal :tax, precision: 12, scale: 3, default: 0

      t.timestamps null: false
    end
  end
end
