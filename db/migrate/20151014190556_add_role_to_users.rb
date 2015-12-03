class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :integer, default: 0
    User.update_all(role: 0)
  end
end
