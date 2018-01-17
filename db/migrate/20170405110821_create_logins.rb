class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|

      t.string :code, null: false
      t.references :user, null: true
      t.string :ip, null: false
      t.integer :network_type, null: false
      t.string :ssid, null: true
      t.float :latitude, null: true
      t.float :longitude, null: true
      t.integer :state, null: false, default: 0
      t.string :denied_reason, null: true
      t.timestamps null: false
    end

    add_index :logins, :code, unique: true

    add_foreign_key :logins, :users
  end
end
