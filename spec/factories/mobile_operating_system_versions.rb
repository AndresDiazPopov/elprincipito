FactoryGirl.define do
  factory :mobile_operating_system_version do
    mobile_operating_system
    name { Faker::App.version }
  end
end
