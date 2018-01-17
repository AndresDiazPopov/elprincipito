class AddMissingForeignKeys2 < ActiveRecord::Migration
  def change
    add_foreign_key :device_models, :device_manufacturers
    add_foreign_key :devices, :mobile_operating_system_versions
    add_foreign_key :devices, :device_models
    add_foreign_key :logins, :devices
    add_foreign_key :logins, :mobile_operating_system_versions
    add_foreign_key :mobile_operating_system_versions, :mobile_operating_systems
  end
end
