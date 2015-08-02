class ChangeUsersTable < ActiveRecord::Migration
  def up
    change_column_null :users, :email, false
    rename_column :users, :password, :crypted_password
  end

  def down
    change_column_null :users, :email, true
    rename_column :users, :crypted_password, :password
  end
end
