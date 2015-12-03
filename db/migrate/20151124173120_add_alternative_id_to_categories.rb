class AddAlternativeIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :alternative_id, :integer
  end
end
