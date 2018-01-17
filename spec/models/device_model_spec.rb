require 'rails_helper'

RSpec.describe DeviceModel, type: :model do

  it 'does not allow device_model without device_manufacturer' do
    device_model = build(:device_model, device_manufacturer: nil)
    expect(device_model).to_not be_valid
  end

  it 'does not allow device_model without name' do
    device_model = build(:device_model, name: nil)
    expect(device_model).to_not be_valid
  end

end
