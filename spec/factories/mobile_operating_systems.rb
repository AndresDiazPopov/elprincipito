FactoryGirl.define do
  factory :mobile_operating_system do
    name { %w[Android iOS].sample }
  end
end
