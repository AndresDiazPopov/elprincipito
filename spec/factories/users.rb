require 'faker'

FactoryGirl.define do
  factory :user do
    email {Faker::Internet.unique.email}
    password {Faker::Internet.password}
    
    state 'enabled'
    
    after(:build) do |u|
      u.skip_confirmation!
    end
  end
end