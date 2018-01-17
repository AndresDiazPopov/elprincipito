FactoryGirl.define do
  factory :app_version do
    name { Faker::App.version }
    mobile_operating_system
  end
end
