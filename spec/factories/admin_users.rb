require 'faker'

FactoryGirl.define do
  factory :admin_user do
    full_name {Faker::Name.name}
    email {Faker::Internet.email}
    password {Faker::Internet.password}

    state 'enabled'

    trait :admin do
      after(:create) do |u|
        u.has_role!(:admin)
      end
    end
  end
end