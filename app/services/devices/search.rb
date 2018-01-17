class Devices::Search

  def self.call(user: nil, device_manufacturer: nil, mobile_operating_system: nil)
    devices = Device.all
    
    devices = devices.where(user: user) if user

    devices = devices.joins(device_model: :device_manufacturer)
      .where(device_manufacturers: {id: device_manufacturer}) if device_manufacturer

    devices = devices.joins(mobile_operating_system_version: :mobile_operating_system)
      .where(mobile_operating_systems: {id: mobile_operating_system}) if mobile_operating_system

    devices
  end

end