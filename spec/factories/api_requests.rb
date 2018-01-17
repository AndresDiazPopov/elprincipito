FactoryGirl.define do
  factory :api_request do
    user
    login
    path { Faker::Internet.url('')[7..-1] }
    params { Faker::Lorem.word }
    ip {Faker::Internet.public_ip_v4_address}
    network_type { Login.network_types.values.sample }
  end
end
