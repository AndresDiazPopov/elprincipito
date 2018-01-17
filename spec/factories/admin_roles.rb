require 'faker'

FactoryGirl.define do
  factory :admin_role do
    name {Faker::Lorem.word}
  end
end