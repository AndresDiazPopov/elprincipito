class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.references    :user,                null: true
      t.string        :device_token,        null: false
      t.string        :platform,            null: false
      t.string        :platform_version,    null: false

      t.timestamps null: false
    end
    add_index :devices, :user_id
  end
end
