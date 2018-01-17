require 'rails_helper'

RSpec.describe AppVersion, type: :model do

  it 'do not allow empty name' do
    model = build(:app_version, name: nil)
    expect(model).to_not be_valid
  end

  it 'do not allow empty mobile_operating_system' do
    model = build(:app_version, mobile_operating_system: nil)
    expect(model).to_not be_valid
  end

  it 'allows empty expired_at' do
    model = build(:app_version, expired_at: nil)
    expect(model).to be_valid
  end

  context 'when another app_version exists' do

    let(:app_version) { create(:app_version) }
  
    it 'does not allow app_version with the same name and mobile_operating_system' do
      another_model = build(:app_version, name: app_version.name, mobile_operating_system: app_version.mobile_operating_system)
      expect(another_model).to_not be_valid
    end

  end

end
