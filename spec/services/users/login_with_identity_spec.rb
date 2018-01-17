require "rails_helper"

describe Users::LoginWithIdentity do

  subject { Users::LoginWithIdentity }
  
  let(:login_params) { {
    network_type: Login.network_types.keys.sample,
    ip: Faker::Internet.public_ip_v4_address,
    ssid: Faker::Lorem.word
  } }

  let(:device_params) { {
    unique_identifier: Faker::Lorem.unique.characters(10),
    mobile_operating_system_name: Faker::Company.name, 
    mobile_operating_system_version_name: Faker::App.version,
    device_manufacturer_name: Faker::Company.name,
    device_model_name: Faker::Company.name
  } }

  context 'when a user exists' do

    let(:user) { create(:user) }
    let(:identity) { build(:identity, :google_oauth2) }

    describe 'call' do

      context 'when the user has an identity' do
      
        before do
          user.identities = [identity]
          user.save
        end

        it 'returns the user when passing existing identity credentials' do
          expect(
            subject.call(
              provider_name: identity.provider,
              provider_uid: identity.uid,
              provider_token: identity.token,
              login_params: login_params,
              device_params: device_params)[0]
            ).to eq(user)
        end

        it 'creates an authorized login' do
          expect{
            subject.call(
                provider_name: identity.provider,
                provider_uid: identity.uid,
                provider_token: identity.token,
                login_params: login_params,
                device_params: device_params)
          }.to change{Login.authorized.count}.by(1)
        end

        it 'raises Exceptions::NotFoundError when passing unexisting identity provider' do
          expect{
            subject.call(
              provider_name: Faker::Lorem.word,
              provider_uid: identity.uid,
              provider_token: identity.token,
              login_params: login_params,
              device_params: device_params)
            }.to raise_error(Exceptions::NotFoundError)
        end

        it 'raises Exceptions::NotFoundError when passing unexisting identity uid' do
          expect{
            subject.call(
              provider_name: identity.provider,
              provider_uid: Faker::Lorem.word,
              provider_token: identity.token,
              login_params: login_params,
              device_params: device_params)
            }.to raise_error(Exceptions::NotFoundError)
        end

        it 'updates the identity token if changed' do
          new_token = Faker::Lorem.word
          expect{
            subject.call(
              provider_name: identity.provider,
              provider_uid: identity.uid,
              provider_token: new_token,
              login_params: login_params,
              device_params: device_params)[0]
            }.to change{identity.reload.token}
        end

        context 'when an unexpired app_version exists' do

          let!(:app_version) { create(:app_version, expired_at: nil) }

          before(:each) do
            login_params[:app_version_name] = app_version.name
          end

          it 'creates an authorized login' do
            expect{
              subject.call(
                provider_name: identity.provider,
                provider_uid: identity.uid,
                provider_token: identity.token,
                login_params: login_params,
                device_params: device_params)
            }.to change{Login.authorized.count}.by(1)
          end

        end

        context 'when an future-expiring app_version exists' do

          let!(:app_version) { create(:app_version, expired_at: 2.days.from_now) }

          before(:each) do
            login_params[:app_version_name] = app_version.name
          end

          it 'creates an authorized login' do
            expect{
              subject.call(
                provider_name: identity.provider,
                provider_uid: identity.uid,
                provider_token: identity.token,
                login_params: login_params,
                device_params: device_params)
            }.to change{Login.authorized.count}.by(1)
          end

        end

        context 'when an expired app_version exists' do

          let!(:app_version) { create(:app_version, 
            expired_at: 10.days.ago, 
            expired_message: Faker::Lorem.word, 
            mobile_operating_system: MobileOperatingSystem.create(name: device_params[:mobile_operating_system_name])) }

          before(:each) do
            login_params[:app_version_name] = app_version.name
          end

          it 'creates a denied login' do
            expect{
              subject.call(
                provider_name: identity.provider,
                provider_uid: identity.uid,
                provider_token: identity.token,
                login_params: login_params,
                device_params: device_params) rescue nil
            }.to change{Login.denied.count}.by(1)
          end

          it 'raises Exceptions::AppVersionExpired when using an unexisting api_key' do
            expect{
              subject.call(
                provider_name: identity.provider,
                provider_uid: identity.uid,
                provider_token: identity.token,
                login_params: login_params,
                device_params: device_params)
              }.to raise_error(Exceptions::AppVersionExpiredError)
          end

        end

      end

    end

  end

end