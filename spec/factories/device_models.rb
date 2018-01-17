FactoryGirl.define do
  factory :device_model do
    device_manufacturer
    name { Faker::Company.name }
  end
end
