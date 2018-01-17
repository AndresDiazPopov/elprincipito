require 'faker'

FactoryGirl.define do
  factory :identity do
    provider 'google_oauth2'
    uid {Faker::Lorem.characters(10)}
    token {Faker::Lorem.characters(10)}
    user

    trait :facebook do
      provider 'facebook'
    end

    trait :google_oauth2 do
      provider 'google_oauth2'
    end

    trait :twitter do
      provider 'twitter'
      token_secret {Faker::Lorem.characters(10)}
    end
  end
end