FactoryGirl.define do
  factory :login do
    user
    ip {Faker::Internet.public_ip_v4_address}
    network_type { Login.network_types.values.sample }
    state {:requested}
    
  end
end
