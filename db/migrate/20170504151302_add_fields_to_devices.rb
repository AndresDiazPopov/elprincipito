class AddFieldsToDevices < ActiveRecord::Migration
  def self.up
    change_column :devices, :device_token, :string, null: true
    remove_column :devices, :platform
    remove_column :devices, :platform_version
    add_reference :devices, :mobile_operating_system_version, null: false, index: true
    add_reference :devices, :device_model, null: false, index: true
    add_column :devices, :unique_identifier, :string, null: false, limit: 2056, index: true
  end

  def self.down
    change_column :devices, :device_token, :string, null: false, default: ''
    add_column :devices, :platform, :string
    add_column :devices, :platform_version, :string
    remove_column :devices, :mobile_operating_system_version_id
    remove_column :devices, :device_model_id
    remove_column :devices, :unique_identifier
  end
end
