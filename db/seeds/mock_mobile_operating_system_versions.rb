20.times do
  MobileOperatingSystemVersion.create(mobile_operating_system: MobileOperatingSystem.all.sample, name: Faker::App.version)
end