require "rails_helper"

describe Devices::CreateOrUpdate do

  subject { Devices::CreateOrUpdate }

  let(:user) { create(:user) }

  describe 'call' do

    it 'creates a device' do
      unique_identifier = Faker::Lorem.unique.characters(10)
      expect{
        subject.call(
          unique_identifier: unique_identifier,
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name,
          user: user)
        }.to change{Device.count}.by(1)
    end

    it 'creates a mobile_operating_system' do
      unique_identifier = Faker::Lorem.unique.characters(10)
      expect{
        subject.call(
          unique_identifier: unique_identifier,
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name,
          user: user)
        }.to change{MobileOperatingSystem.count}.by(1)
    end

    it 'creates a mobile_operating_system_version' do
      unique_identifier = Faker::Lorem.unique.characters(10)
      expect{
        subject.call(
          unique_identifier: unique_identifier,
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name,
          user: user)
        }.to change{MobileOperatingSystemVersion.count}.by(1)
    end

    it 'creates a device_manufacturer' do
      unique_identifier = Faker::Lorem.unique.characters(10)
      expect{
        subject.call(
          unique_identifier: unique_identifier,
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name,
          user: user)
        }.to change{DeviceManufacturer.count}.by(1)
    end

    it 'creates a device_model' do
      unique_identifier = Faker::Lorem.unique.characters(10)
      expect{
        subject.call(
          unique_identifier: unique_identifier,
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name,
          user: user)
        }.to change{DeviceModel.count}.by(1)
    end

    context 'when an mobile_operating_system exist' do

      let!(:mobile_operating_system) { create(:mobile_operating_system) }

      it 'does not create another mobile_operating_system' do
        unique_identifier = Faker::Lorem.unique.characters(10)
        expect{
          subject.call(
            unique_identifier: unique_identifier,
            mobile_operating_system_name: mobile_operating_system.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name,
            user: user)
          }.not_to change{MobileOperatingSystem.count}
      end

      it 'creates a mobile_operating_system_version' do
        unique_identifier = Faker::Lorem.unique.characters(10)
        expect{
          subject.call(
            unique_identifier: unique_identifier,
            mobile_operating_system_name: mobile_operating_system.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name,
            user: user)
          }.to change{MobileOperatingSystemVersion.count}.by(1)
      end

    end

    context 'when an mobile_operating_system_version exist' do

      let!(:mobile_operating_system_version) { create(:mobile_operating_system_version) }

      it 'does not create another mobile_operating_system_version' do
        unique_identifier = Faker::Lorem.unique.characters(10)
        expect{
          subject.call(
            unique_identifier: unique_identifier,
            mobile_operating_system_name: mobile_operating_system_version.mobile_operating_system.name, 
            mobile_operating_system_version_name: mobile_operating_system_version.name,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name,
            user: user)
          }.not_to change{MobileOperatingSystemVersion.count}
      end

    end

    context 'when an device_manufacturer exist' do

      let!(:device_manufacturer) { create(:device_manufacturer) }

      it 'does not create another device_manufacturer' do
        unique_identifier = Faker::Lorem.unique.characters(10)
        expect{
          subject.call(
            unique_identifier: unique_identifier,
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: device_manufacturer.name,
            device_model_name: Faker::Company.name,
            user: user)
          }.not_to change{DeviceManufacturer.count}
      end

    end

    context 'when an device_model exist' do

      let!(:device_model) { create(:device_model) }

      it 'does not create another device_model' do
        unique_identifier = Faker::Lorem.unique.characters(10)
        expect{
          subject.call(
            unique_identifier: unique_identifier,
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: device_model.device_manufacturer.name,
            device_model_name: device_model.name,
            user: user)
          }.not_to change{DeviceModel.count}
      end

    end

  end

end