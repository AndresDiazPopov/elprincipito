200.times do
  mobile_operating_system_version = MobileOperatingSystemVersion.all.sample
  device_model = DeviceModel.all.sample
  Devices::CreateOrUpdate.call(
    unique_identifier: Faker::Lorem.unique.characters(10),
    mobile_operating_system_name: mobile_operating_system_version.mobile_operating_system.name, 
    mobile_operating_system_version_name: mobile_operating_system_version.name,
    device_manufacturer_name: device_model.device_manufacturer.name,
    device_model_name: device_model.name,
    user: User.all.sample)
end