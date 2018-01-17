require "rails_helper"

describe Devices::Search do

  subject { Devices::Search }

  context 'when no devices exists' do

    describe 'call' do

      it 'returns empty array' do
        expect(
          subject.call
          ).to match_array([])
      end

    end

  end

  context 'when multiple devices exist' do

    let(:devices) { create_list(:device, 26) }

    describe 'call' do

      it 'returns paginated devices' do
        expect(
          subject.call
          ).to match_array(Device.all)
      end

    end

  end

  context 'when multiple devices of multiple users exist' do

    let(:users) { create_list(:user, 10) }
    let(:devices) { {} }
    
    before(:each) do
      users.each do |user|
        devices[user.email] = create_list(:device, 5, user: user)
      end
    end

    describe 'call' do

      it 'returns only devices for the specified user' do
        selected_user = users.sample
        
        result = subject.call(user: selected_user)
        expect(result.count).to eq(5)

        result.each do |device|
          expect(device.user).to eq(selected_user)
        end
        
      end

    end

  end

  context 'when multiple devices with multiple device_models exist' do
    
    let(:device_model_1) { create(:device_model) }
    let(:device_model_2) { create(:device_model) }
    let(:device_model_3) { create(:device_model) }
    let(:mobile_operating_system_version_1) { create(:mobile_operating_system_version) }
    let(:mobile_operating_system_version_2) { create(:mobile_operating_system_version) }
    let(:mobile_operating_system_version_3) { create(:mobile_operating_system_version) }
    let(:device_list_1) { create_list(:device, 5, device_model: device_model_1, mobile_operating_system_version: mobile_operating_system_version_1) }
    let(:device_list_2) { create_list(:device, 5, device_model: device_model_2, mobile_operating_system_version: mobile_operating_system_version_2) }
    let(:device_list_3) { create_list(:device, 5, device_model: device_model_3, mobile_operating_system_version: mobile_operating_system_version_3) }

    it 'returns only devices of requested device manufacturers' do
      
      result = subject.call(device_manufacturer: device_model_1.device_manufacturer)
      
      result.each do |device|
        expect(device.device_manufacturer).to eq(device_model_1.device_manufacturer)
      end
      
    end

    it 'returns only devices of requested mobile_operating_systems' do
      
      result = subject.call(mobile_operating_system: mobile_operating_system_version_1.mobile_operating_system)
      
      result.each do |device|
        expect(device.mobile_operating_system_version.mobile_operating_system).to eq(device_model_1.mobile_operating_system_version.mobile_operating_system)
      end
      
    end

  end

end