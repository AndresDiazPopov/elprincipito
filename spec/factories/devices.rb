require 'faker'

FactoryGirl.define do
  factory :device do
    sequence(:unique_identifier)
    device_token {Faker::Lorem.characters(10)}
    mobile_operating_system_version
    device_model

    trait :with_user do
      user
    end

    trait :iphone do
      platform 'iphone'
    end

    trait :ipad do
      platform 'ipad'
    end

    trait :android do
      platform 'android'
    end
  end
end