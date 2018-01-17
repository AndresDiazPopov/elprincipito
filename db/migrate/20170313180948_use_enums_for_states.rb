class UseEnumsForStates < ActiveRecord::Migration
  def self.up

    # AdminUser
    add_column :admin_users, :state_new, :integer, null: false, default: 1

    AdminUser.where(state: :enabled).update_all(state_new: 1)
    AdminUser.where(state: :disabled).update_all(state_new: 0)

    remove_column :admin_users, :state

    rename_column :admin_users, :state_new, :state

  end

  def self.down
    # AdminUser
    add_column :admin_users, :state_new, :string

    AdminUser.where(state: 1).update_all(state_new: :enabled)
    AdminUser.where(state: 0).update_all(state_new: :disabled)

    remove_column :admin_users, :state

    rename_column :admin_users, :state_new, :state
    
  end
end
