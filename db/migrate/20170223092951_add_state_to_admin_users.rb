class AddStateToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :state, :string
  end
end
