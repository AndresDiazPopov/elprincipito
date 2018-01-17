20.times do
  DeviceModel.create(device_manufacturer: DeviceManufacturer.all.sample, name: Faker::Company.name)
end