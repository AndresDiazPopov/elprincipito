require "rails_helper"

describe Logins::Create do

  subject { Logins::Create }

  context 'when no logins exists' do

    describe 'call' do

      it 'creates a valid login' do
        expect(
          subject.call(login_params: {
            network_type: Login.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word,
            app_version_name: Faker::App.version},
            device_params: {
              unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
              })
          ).to eq(Login.last)
      end

      it 'creates a valid login with user' do
        expect(
          subject.call(login_params: {
            user: create(:user),
            network_type: Login.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word,
            app_version_name: Faker::App.version},
            device_params: {
              unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
              })
          ).to eq(Login.last)
      end

      it 'creates a device' do
        expect{
          subject.call(login_params: {
            user: create(:user),
            network_type: Login.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word,
            app_version_name: Faker::App.version},
            device_params: {
              unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
              }
            )
          }.to change{Device.count}.by(1)
      end

      it 'assigns a device to the login' do
        login = subject.call(login_params: {
          user: create(:user),
          network_type: Login.network_types.keys.sample,
          ip: Faker::Internet.public_ip_v4_address,
          ssid: Faker::Lorem.word,
          app_version_name: Faker::App.version},
          device_params: {
            unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
            }
          )
        expect(login.device).not_to be_nil
      end

      it 'creates a mobile_operating_system_version' do
        expect{
          subject.call(login_params: {
            user: create(:user),
            network_type: Login.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word,
            app_version_name: Faker::App.version},
            device_params: {
              unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
              }
            )
          }.to change{MobileOperatingSystemVersion.count}.by(1)
      end

      it 'assigns a mobile_operating_system_version to the login' do
        login = subject.call(login_params: {
          user: create(:user),
          network_type: Login.network_types.keys.sample,
          ip: Faker::Internet.public_ip_v4_address,
          ssid: Faker::Lorem.word,
          app_version_name: Faker::App.version},
          device_params: {
            unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
            }
          )
        expect(login.mobile_operating_system_version).not_to be_nil
      end

      it 'creates an app_version if it does not exist' do
        expect{
          subject.call(login_params: {
            user: create(:user),
            network_type: Login.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word,
            app_version_name: Faker::App.version
            },
            device_params: {
              unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
              }
            )
        }.to change{AppVersion.count}.by(1)
      end

      it 'creates the login if app_version_name is not specified' do
        expect{
          subject.call(login_params: {
            user: create(:user),
            network_type: Login.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word
            },
            device_params: {
              unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
              }
            )
        }.to change{Login.count}.by(1)
      end

      it 'does not create any app_version if app_version_name is not specified' do
        expect{
          subject.call(login_params: {
            user: create(:user),
            network_type: Login.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word
            },
            device_params: {
              unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
              }
            )
        }.to_not change{AppVersion.count}
      end

      it 'does not set app_version to the created login if app_version_name is not specified' do
        login = subject.call(login_params: {
          user: create(:user),
          network_type: Login.network_types.keys.sample,
          ip: Faker::Internet.public_ip_v4_address,
          ssid: Faker::Lorem.word
          },
          device_params: {
            unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
            }
          )
        expect(login.app_version).to be_nil
      end

      context 'when a device exists' do
        
        let!(:device) { create(:device) }

        it 'assigns a device to the login' do
          login = subject.call(login_params: {
            user: create(:user),
            network_type: Login.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word,
            app_version_name: Faker::App.version},
            device_params: {
              unique_identifier: device.unique_identifier,
              mobile_operating_system_name: device.mobile_operating_system_version.mobile_operating_system.name, 
              mobile_operating_system_version_name: device.mobile_operating_system_version.name, 
              device_manufacturer_name: device.device_model.device_manufacturer.name, 
              device_model_name: device.device_model.name
              }
            )
          expect(login.device).not_to be_nil
        end

        it 'does not create the device' do
          expect{
            subject.call(login_params: {
              user: create(:user),
              network_type: Login.network_types.keys.sample,
              ip: Faker::Internet.public_ip_v4_address,
              ssid: Faker::Lorem.word,
              app_version_name: Faker::App.version},
              device_params: {
                unique_identifier: device.unique_identifier,
                mobile_operating_system_name: device.mobile_operating_system_version.mobile_operating_system.name, 
                mobile_operating_system_version_name: device.mobile_operating_system_version.name, 
                device_manufacturer_name: device.device_model.device_manufacturer.name, 
                device_model_name: device.device_model.name
                }
              )
            }.not_to change{Device.count}
        end

      end

      context 'when a mobile_operating_system_version exists' do
        
        let!(:mobile_operating_system_version) { create(:mobile_operating_system_version) }
        let!(:device) { create(:device, mobile_operating_system_version: mobile_operating_system_version) }

        it 'assigns a mobile_operating_system_version to the login' do
          login = subject.call(login_params: {
            user: create(:user),
            network_type: Login.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word,
            app_version_name: Faker::App.version},
            device_params: {
              unique_identifier: device.unique_identifier,
              mobile_operating_system_name: device.mobile_operating_system_version.mobile_operating_system.name, 
              mobile_operating_system_version_name: device.mobile_operating_system_version.name, 
              device_manufacturer_name: device.device_model.device_manufacturer.name, 
              device_model_name: device.device_model.name
              }
            )
          expect(login.mobile_operating_system_version).not_to be_nil
        end

        it 'does not create the mobile_operating_system_version' do
          expect{
            subject.call(login_params: {
              user: create(:user),
              network_type: Login.network_types.keys.sample,
              ip: Faker::Internet.public_ip_v4_address,
              ssid: Faker::Lorem.word,
              app_version_name: Faker::App.version},
              device_params: {
                unique_identifier: device.unique_identifier,
                mobile_operating_system_name: device.mobile_operating_system_version.mobile_operating_system.name, 
                mobile_operating_system_version_name: device.mobile_operating_system_version.name, 
                device_manufacturer_name: device.device_model.device_manufacturer.name, 
                device_model_name: device.device_model.name
                }
              )
            }.not_to change{MobileOperatingSystemVersion.count}
        end

      end

      context 'when an app_version exists' do
        
        let!(:mobile_operating_system) { create(:mobile_operating_system) }
        let!(:app_version) { create(:app_version, mobile_operating_system: mobile_operating_system) }

        it 'assigns an app_version to the login' do
          login = subject.call(login_params: {
            user: create(:user),
            network_type: Login.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word,
            app_version_name: app_version.name},
            device_params: {
              unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: app_version.mobile_operating_system.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
              }
            )
          expect(login.app_version).to eq(app_version)
        end

        it 'does not create the app_version' do
          expect{
            subject.call(login_params: {
              user: create(:user),
              network_type: Login.network_types.keys.sample,
              ip: Faker::Internet.public_ip_v4_address,
              ssid: Faker::Lorem.word,
              app_version_name: app_version.name},
              device_params: {
                unique_identifier: Faker::Lorem.unique.characters(10),
                mobile_operating_system_name: app_version.mobile_operating_system.name, 
                mobile_operating_system_version_name: Faker::App.version,
                device_manufacturer_name: Faker::Company.name,
                device_model_name: Faker::Company.name
                }
              )
            }.not_to change{AppVersion.count}
        end

      end

    end

  end

end