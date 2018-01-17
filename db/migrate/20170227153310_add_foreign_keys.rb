class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :admin_roles_admin_users, :admin_roles
    add_foreign_key :admin_roles_admin_users, :admin_users

    add_foreign_key :devices, :users

    add_foreign_key :identities, :users

    add_foreign_key :roles_users, :roles
    add_foreign_key :roles_users, :users
  end
end
