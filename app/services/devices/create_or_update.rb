class Devices::CreateOrUpdate

  def self.call(
    unique_identifier:,
    mobile_operating_system_name:, 
    mobile_operating_system_version_name:,
    device_manufacturer_name:,
    device_model_name:,
    user:)

    device = Device.find_or_initialize_by(unique_identifier: unique_identifier)
    
    Device.transaction do

      # Se crea/obtiene el OS
      mobile_operating_system = MobileOperatingSystem.find_or_create_by(
        name: mobile_operating_system_name)

      # Se crea/obtiene la versión del OS
      mobile_operating_system_version = MobileOperatingSystemVersion.find_or_create_by(
        mobile_operating_system: mobile_operating_system,
        name: mobile_operating_system_version_name)

      # Se crea/obtiene la marca del dispositivo
      device_manufacturer = DeviceManufacturer.find_or_create_by(
        name: device_manufacturer_name)

      # Se crea/obtiene el modelo del dispositivo
      device_model = DeviceModel.find_or_create_by(
        device_manufacturer: device_manufacturer,
        name: device_model_name)

      device.update_attributes!(
        mobile_operating_system_version: mobile_operating_system_version,
        device_model: device_model,
        user: user)
    end
    device

  end

end