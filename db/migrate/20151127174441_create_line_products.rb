class CreateLineProducts < ActiveRecord::Migration
  def change
    create_table :line_products do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
