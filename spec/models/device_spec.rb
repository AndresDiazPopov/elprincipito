require "rails_helper"

describe Device do

  it 'does not allow device without unique_identifier' do
    device = build(:device, unique_identifier: nil)
    expect(device).to_not be_valid
  end

  it 'does not allow device without mobile_operating_system_version' do
    device = build(:device, mobile_operating_system_version: nil)
    expect(device).to_not be_valid
  end

  it 'does not allow device without device_model' do
    device = build(:device, device_model: nil)
    expect(device).to_not be_valid
  end

  it 'allow device without user' do
    device = build(:device, user: nil)
    expect(device).to be_valid
  end

  it 'allow device without device_token' do
    device = build(:device, device_token: nil)
    expect(device).to be_valid
  end

  context 'when another device exists' do

    let(:device) { create(:device) }

    it 'does not allow another device with the same unique_identifier' do
      another_device = build(:device, unique_identifier: device.unique_identifier)
      expect(another_device).to_not be_valid
    end

  end

end