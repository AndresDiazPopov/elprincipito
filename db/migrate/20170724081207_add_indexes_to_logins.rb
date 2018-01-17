class AddIndexesToLogins < ActiveRecord::Migration
  def change
    add_index :logins, :ip, unique: false
    add_index :logins, :created_at, unique: false
  end
end
