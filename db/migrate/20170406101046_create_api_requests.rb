class CreateApiRequests < ActiveRecord::Migration
  def change
    create_table :api_requests do |t|

      t.string :path, null: false
      t.text :params, null: false
      t.references :login, null: true
      t.references :user, null: true
      t.string :ip, null: false
      t.integer :network_type, null: true
      t.string :ssid, null: true
      t.float :latitude, null: true
      t.float :longitude, null: true
      t.timestamps null: false
    end

    add_foreign_key :api_requests, :users
    add_foreign_key :api_requests, :logins
  end
end
