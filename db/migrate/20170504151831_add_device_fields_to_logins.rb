class AddDeviceFieldsToLogins < ActiveRecord::Migration
  def change
    # Son nullables porque ya hay datos
    add_reference :logins, :device, null: true
    add_reference :logins, :mobile_operating_system_version, null: true, index: true
  end
end
