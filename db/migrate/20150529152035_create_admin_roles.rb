class CreateAdminRoles < ActiveRecord::Migration
  def change
    create_table :admin_roles do |t|
      t.string   :name,                   null: false
      t.string   :authorizable_type,      null: true
      t.integer  :authorizable_id,        null: true
      t.boolean  :system, default: false, null: false
      t.timestamps                        null: false
    end

    add_index :admin_roles, :name
    add_index :admin_roles, [:authorizable_type, :authorizable_id]

    create_table :admin_roles_admin_users, id: false do |t|
      t.references  :admin_user, null: false
      t.references  :admin_role, null: false
    end

    add_index :admin_roles_admin_users, :admin_user_id
    add_index :admin_roles_admin_users, :admin_role_id
  end
end
