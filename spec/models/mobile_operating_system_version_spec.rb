require 'rails_helper'

RSpec.describe MobileOperatingSystemVersion, type: :model do

  it 'does not allow mobile_operating_system_version without mobile_operating_system' do
    mobile_operating_system_version = build(:mobile_operating_system_version, mobile_operating_system: nil)
    expect(mobile_operating_system_version).to_not be_valid
  end

  it 'does not allow mobile_operating_system_version without name' do
    mobile_operating_system_version = build(:mobile_operating_system_version, name: nil)
    expect(mobile_operating_system_version).to_not be_valid
  end

end
