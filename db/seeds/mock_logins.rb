50.times do
  Login.create(
    user: User.all.sample,
    ip: Faker::Internet.public_ip_v4_address,
    network_type: Login.network_types.values.sample,
    device: Device.all.sample,
    mobile_operating_system_version: MobileOperatingSystemVersion.all.sample
    )
end

25.times do
  Login.requested.sample.authorize!
end
25.times do
  login = Login.requested.sample
  login.denied_reason = Faker::Lorem.word
  login.deny
  login.save!
end