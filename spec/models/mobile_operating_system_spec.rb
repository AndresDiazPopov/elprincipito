require 'rails_helper'

RSpec.describe MobileOperatingSystem, type: :model do

  it 'does not allow mobile_operating_system without name' do
    mobile_operating_system = build(:mobile_operating_system, name: nil)
    expect(mobile_operating_system).to_not be_valid
  end

end
