require 'rails_helper'

RSpec.describe DeviceManufacturer, type: :model do

  it 'does not allow device_manufacturer without name' do
    device_manufacturer = build(:device_manufacturer, name: nil)
    expect(device_manufacturer).to_not be_valid
  end

end
