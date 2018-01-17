require "rails_helper"

describe '/users' do
  
  let(:network_type) { Login.network_types.keys.sample }
  let(:ip) { Faker::Internet.public_ip_v4_address }
  let(:ssid) { Faker::Lorem.word }

  context 'when a user exists' do
    
    let(:password) { 'password' }
    let(:user) { create(:user, password: password) }

    context 'when an identity exists' do

      let(:identity) { create(:identity, :google_oauth2, user: user) }

      describe '/create' do

        it 'creates an user with existing provider and different uid' do
          post '/api/v1/users/create', 
            provider_name: identity.provider, 
            provider_uid: Faker::Lorem.characters(10),
            provider_token: Faker::Lorem.characters(10),
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          expect(response).to be_success
          expect_user_after_login
        end

        it 'creates a login instance' do
          expect{
            post '/api/v1/users/create', 
              provider_name: identity.provider, 
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10),
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name,
              locale: 'gl_ES'
            }.to change{Login.count}.by(1)
        end

        it 'logs the api request' do
          expect{
            post '/api/v1/users/create', 
              provider_name: identity.provider, 
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10),
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
          }.to change{ApiRequest.count}.by(1)
        end

        it 'the logged api request has the correct user' do
          post '/api/v1/users/create', 
            provider_name: identity.provider, 
            provider_uid: Faker::Lorem.characters(10),
            provider_token: Faker::Lorem.characters(10),
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          user = User.last
          expect(ApiRequest.last.user).to eq(User.last)
        end

        it 'creates an user with existing provider and different uid' do
          post '/api/v1/users/create',
            provider_name: identity.provider, 
            provider_uid: Faker::Lorem.characters(10),
            provider_token: Faker::Lorem.characters(10),
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          expect(response).to be_success
          expect_user_after_login
        end

        it 'returns already_exists exception with existing provider and uid' do
          post '/api/v1/users/create', 
            provider_name: identity.provider, 
            provider_uid: identity.uid,
            provider_token: Faker::Lorem.characters(10),
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:already_exists])
          expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:conflict])
        end

        it 'logs the api request when an exception occurs' do
          expect{
            post '/api/v1/users/create', 
              provider_name: identity.provider, 
              provider_uid: identity.uid,
              provider_token: Faker::Lorem.characters(10),
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
          }.to change{ApiRequest.count}.by(1)
        end

        context 'when an unexpired app_version exists' do

          let!(:app_version) { create(:app_version, expired_at: nil) }

          it 'returns the user' do
            post '/api/v1/users/create', 
              provider_name: identity.provider, 
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10),
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              app_version_name: app_version.name,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: app_version.mobile_operating_system.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
            expect(response).to be_success
            expect_user_after_login
          end

        end

        context 'when an future-expiring app_version exists' do

          let!(:app_version) { create(:app_version, expired_at: 2.days.from_now) }

          it 'returns the user' do
            post '/api/v1/users/create', 
              provider_name: identity.provider, 
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10),
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              app_version_name: app_version.name,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: app_version.mobile_operating_system.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
            expect(response).to be_success
            expect_user_after_login
          end

        end

        context 'when an expired app_version exists' do

          let!(:app_version) { create(:app_version, 
            expired_at: 10.days.ago, 
            expired_message: Faker::Lorem.word) }

          it 'returns app_version_expired exception' do
            post '/api/v1/users/create', 
              provider_name: identity.provider, 
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10),
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              app_version_name: app_version.name,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: app_version.mobile_operating_system.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name

            expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:app_version_expired])
            expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:unauthorized])
          end

        end

      end

      describe '/login_with_identity' do

        it 'logs in with valid identity' do
          post '/api/v1/users/login_with_identity', 
            provider_name: identity.provider, 
            provider_uid: identity.uid,
            provider_token: identity.token,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          expect(response).to be_success
          expect_user_after_login
        end

        it 'creates a login instance when no locale is specified' do
          expect{
            post '/api/v1/users/login_with_identity', 
              provider_name: identity.provider, 
              provider_uid: identity.uid,
              provider_token: identity.token,
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
            }.to change{Login.count}.by(1)
        end

        it 'creates a login instance with specified data when locale is specified' do
          post '/api/v1/users/login_with_identity', 
            provider_name: identity.provider, 
            provider_uid: identity.uid,
            provider_token: identity.token,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name,
            locale: 'gl_CZ'
          login = Login.last
          expect(login.locale_language).to eq('gl')
          expect(login.locale_country).to eq('CZ')
        end

        it 'does not login with wrong identity uid' do
          post '/api/v1/users/login_with_identity', 
            provider_name: identity.provider, 
            provider_uid: Faker::Lorem.characters(10),
            provider_token: identity.token,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
          expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
        end

        it 'login with wrong identity token (should update the token)' do
          post '/api/v1/users/login_with_identity', 
            provider_name: identity.provider, 
            provider_uid: identity.uid,
            provider_token: Faker::Lorem.characters(10),
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          expect(response).to be_success
          expect_user_after_login
        end

        it 'logs the api request' do
          expect{
            post '/api/v1/users/login_with_identity', 
              provider_name: identity.provider, 
              provider_uid: identity.uid,
              provider_token: identity.token,
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: Faker::Company.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
          }.to change{ApiRequest.count}.by(1)
        end

        it 'the logged api request has the correct user' do
          post '/api/v1/users/login_with_identity', 
            provider_name: identity.provider, 
            provider_uid: identity.uid,
            provider_token: identity.token,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          user = User.last
          expect(ApiRequest.last.user).to eq(User.last)
        end

        it 'logs the api request when an exception occurs' do
          expect{
            post '/api/v1/users/login_with_identity', 
              provider_name: identity.provider, 
              provider_uid: Faker::Lorem.characters(10),
              provider_token: identity.token,
              network_type: network_type,
              ip: ip,
              ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          }.to change{ApiRequest.count}.by(1)
        end

        context 'when an unexpired app_version exists' do

          let!(:app_version) { create(:app_version, expired_at: nil) }

          it 'returns the user' do
            post '/api/v1/users/login_with_identity', 
              provider_name: identity.provider, 
              provider_uid: identity.uid,
              provider_token: identity.token,
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              app_version_name: app_version.name,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: app_version.mobile_operating_system.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
            expect(response).to be_success
            expect_user_after_login
          end

        end

        context 'when an future-expiring app_version exists' do

          let!(:app_version) { create(:app_version, expired_at: 2.days.from_now) }

          it 'returns the user' do
            post '/api/v1/users/login_with_identity', 
              provider_name: identity.provider, 
              provider_uid: identity.uid,
              provider_token: identity.token,
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              app_version_name: app_version.name,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: app_version.mobile_operating_system.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name
            expect(response).to be_success
            expect_user_after_login
          end

        end

        context 'when an expired app_version exists' do

          let!(:app_version) { create(:app_version, 
            expired_at: 10.days.ago, 
            expired_message: Faker::Lorem.word) }

          it 'returns app_version_expired exception' do
            post '/api/v1/users/login_with_identity', 
              provider_name: identity.provider, 
              provider_uid: identity.uid,
              provider_token: identity.token,
              network_type: network_type,
              ip: ip,
              ssid: ssid,
              app_version_name: app_version.name,
              device_unique_identifier: Faker::Lorem.unique.characters(10),
              mobile_operating_system_name: app_version.mobile_operating_system.name, 
              mobile_operating_system_version_name: Faker::App.version,
              device_manufacturer_name: Faker::Company.name,
              device_model_name: Faker::Company.name

            expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:app_version_expired])
            expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:unauthorized])
          end

        end

      end

    end

    describe '/create' do

      it 'returns already_exists exception with existing email' do
        post '/api/v1/users/create', 
          email: user.email,
          provider_name: 'google_oauth2',
          provider_uid: Faker::Lorem.characters(10),
          provider_token: Faker::Lorem.characters(10),
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:already_exists])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:conflict])
      end

    end

    describe '/login_with_api_key' do

      it 'logs in with api key for a valid user' do
        post '/api/v1/users/login_with_api_key', 
          api_key: user.api_key,
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        expect(response).to be_success
        expect_user_after_login
      end

      it 'creates a login instance' do
        expect{
          post '/api/v1/users/login_with_api_key', 
            api_key: user.api_key,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name,
            locale: 'gl_ES'
          }.to change{Login.count}.by(1)
      end

      it 'does not login with a wrong api_key' do
        post '/api/v1/users/login_with_api_key', 
          api_key: Faker::Internet.password(8),
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
      end

      it 'logs the api request' do
        expect{
          post '/api/v1/users/login_with_api_key', 
            api_key: user.api_key,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
        }.to change{ApiRequest.count}.by(1)
      end

      it 'the logged api request has the correct user' do
        post '/api/v1/users/login_with_api_key', 
          api_key: user.api_key,
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        user = User.last
        expect(ApiRequest.last.user).to eq(User.last)
      end

      it 'logs the api request when an exception occurs' do
        expect{
          post '/api/v1/users/login_with_api_key', 
            api_key: Faker::Internet.password(8),
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
        }.to change{ApiRequest.count}.by(1)
      end

      context 'when an unexpired app_version exists' do

        let!(:app_version) { create(:app_version, expired_at: nil) }

        it 'returns the user' do
          post '/api/v1/users/login_with_api_key', 
            api_key: user.api_key,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            app_version_name: app_version.name,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: app_version.mobile_operating_system.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          expect(response).to be_success
          expect_user_after_login
        end

      end

      context 'when an future-expiring app_version exists' do

        let!(:app_version) { create(:app_version, expired_at: 2.days.from_now) }

        it 'returns the user' do
          post '/api/v1/users/login_with_api_key', 
            api_key: user.api_key,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            app_version_name: app_version.name,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: app_version.mobile_operating_system.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          expect(response).to be_success
          expect_user_after_login
        end

      end

      context 'when an expired app_version exists' do

        let!(:app_version) { create(:app_version, 
          expired_at: 10.days.ago, 
          expired_message: Faker::Lorem.word) }

        it 'returns app_version_expired exception' do
          post '/api/v1/users/login_with_api_key', 
            api_key: user.api_key,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            app_version_name: app_version.name,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: app_version.mobile_operating_system.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name

          expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:app_version_expired])
          expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:unauthorized])
        end

        it 'returns app_version_expired exception with correct message' do
          post '/api/v1/users/login_with_api_key', 
            api_key: user.api_key,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            app_version_name: app_version.name,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: app_version.mobile_operating_system.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name

          expect_json('exception.message', app_version.expired_message)
        end

      end

    end

    describe '/login_with_email' do

      it 'logs in with api key for a valid user' do
        post '/api/v1/users/login_with_email', 
          email: user.email,
          password: password,
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        expect(response).to be_success
        expect_user_after_login
      end

      it 'creates a login instance' do
        expect{
          post '/api/v1/users/login_with_email', 
            email: user.email,
            password: password,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name,
            locale: 'gl_ES'
          }.to change{Login.count}.by(1)
      end

      it 'does not login with a wrong email' do
        post '/api/v1/users/login_with_email', 
          email: Faker::Internet.password(8),
          password: password,
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
      end

      it 'does not login with a wrong password' do
        post '/api/v1/users/login_with_email', 
          email: user.email,
          password: Faker::Internet.password(8),
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
      end

      it 'logs the api request' do
        expect{
          post '/api/v1/users/login_with_email', 
            email: user.email,
            password: password,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
        }.to change{ApiRequest.count}.by(1)
      end

      it 'the logged api request has the correct user' do
        post '/api/v1/users/login_with_email', 
          email: user.email,
          password: password,
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        user = User.last
        expect(ApiRequest.last.user).to eq(User.last)
      end

      it 'logs the api request when an exception occurs' do
        expect{
          post '/api/v1/users/login_with_email', 
            email: Faker::Internet.password(8),
            password: password,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: Faker::Company.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
        }.to change{ApiRequest.count}.by(1)
      end

      context 'when an unexpired app_version exists' do

        let!(:app_version) { create(:app_version, expired_at: nil) }

        it 'returns the user' do
          post '/api/v1/users/login_with_email', 
            email: user.email,
            password: password,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            app_version_name: app_version.name,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: app_version.mobile_operating_system.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          expect(response).to be_success
          expect_user_after_login
        end

      end

      context 'when an future-expiring app_version exists' do

        let!(:app_version) { create(:app_version, expired_at: 2.days.from_now) }

        it 'returns the user' do
          post '/api/v1/users/login_with_email', 
            email: user.email,
            password: password,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            app_version_name: app_version.name,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: app_version.mobile_operating_system.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name
          expect(response).to be_success
          expect_user_after_login
        end

      end

      context 'when an expired app_version exists' do

        let!(:app_version) { create(:app_version, 
          expired_at: 10.days.ago, 
          expired_message: Faker::Lorem.word) }

        it 'returns app_version_expired exception' do
          post '/api/v1/users/login_with_email', 
            email: user.email,
            password: password,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            app_version_name: app_version.name,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: app_version.mobile_operating_system.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name

          expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:app_version_expired])
          expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:unauthorized])
        end

        it 'returns app_version_expired exception with correct message' do
          post '/api/v1/users/login_with_email', 
            email: user.email,
            password: password,
            network_type: network_type,
            ip: ip,
            ssid: ssid,
            app_version_name: app_version.name,
            device_unique_identifier: Faker::Lorem.unique.characters(10),
            mobile_operating_system_name: app_version.mobile_operating_system.name, 
            mobile_operating_system_version_name: Faker::App.version,
            device_manufacturer_name: Faker::Company.name,
            device_model_name: Faker::Company.name

          expect_json('exception.message', app_version.expired_message)
        end

      end

    end

    describe '/show' do

      it 'returns a valid user' do
        get '/api/v1/users/show', 
          api_key: user.api_key,
          id: user.id
        expect(response).to be_success
        expect_json_types('user', JsonSchemas::USER)
      end

      it 'returns not_found for non existing id' do

        get '/api/v1/users/show', 
          api_key: user.api_key,
          id: user.id + 1
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
      end

    end

    describe '/update' do

      it 'returns the user' do
        post '/api/v1/users/update', 
          api_key: user.api_key,
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        expect(response).to be_success
        expect_json_types('user', JsonSchemas::USER_PRIVATE)
      end

      it 'returns the user when updating picture' do
        post '/api/v1/users/update', 
          api_key: user.api_key,
          image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/default.jpg", "image/jpeg"),
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        expect(response).to be_success
        expect_json_types('user', JsonSchemas::USER_PRIVATE)
      end

      it 'returns the user when updating password' do
        post '/api/v1/users/update', 
          api_key: user.api_key,
          old_password: password,
          new_password: Faker::Internet.password(8),
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        expect(response).to be_success
        expect_json_types('user', JsonSchemas::USER_PRIVATE)
      end

      it 'returns unauthorized when updating password using wrong old_password' do
        post '/api/v1/users/update', 
          api_key: user.api_key,
          old_password: Faker::Internet.password(8),
          new_password: Faker::Internet.password(8),
          network_type: network_type,
          ip: ip,
          ssid: ssid,
          device_unique_identifier: Faker::Lorem.unique.characters(10),
          mobile_operating_system_name: Faker::Company.name, 
          mobile_operating_system_version_name: Faker::App.version,
          device_manufacturer_name: Faker::Company.name,
          device_model_name: Faker::Company.name
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:unauthorized])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:unauthorized])
      end

    end

    describe '/request_password_reset_instructions' do

      it 'returns a valid user' do
        post '/api/v1/users/request_password_reset_instructions', 
          email: user.email
        expect(response).to be_success
      end

      it 'returns not_found when using wrong email' do
        post '/api/v1/users/request_password_reset_instructions', 
          email: Faker::Internet.email
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
      end

    end

    describe '/reset_password' do

      it 'returns not_found when using wrong email' do
        post '/api/v1/users/reset_password', 
          email: Faker::Internet.email,
          code: Faker::Number.number(4),
          password: Faker::Internet.password(8)
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
      end

      it 'returns not_found when using wrong code' do
        post '/api/v1/users/reset_password', 
          email: user.email,
          code: Faker::Number.number(4),
          password: Faker::Internet.password(8)
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
      end

      context 'when the user requested password reset instructions' do

        before(:each) do
          Users::RequestPasswordResetInstructions.call(email: user.email)
          user.reload
        end

        it 'returns not_found when using wrong code' do
          post '/api/v1/users/reset_password', 
            email: user.email,
            code: Faker::Number.number(4),
            password: Faker::Internet.password(8)
          expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
          expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
        end

        it 'returns success when using correct code' do
          post '/api/v1/users/reset_password', 
            email: user.email,
            code: user.reset_password_token,
            password: Faker::Internet.password(8)
          expect(response).to be_success
        end

        context 'when the reset password token is expired' do

          before(:each) do
            user.update_attributes(reset_password_sent_at: 1.year.ago)
          end

          it 'returns not_found when code expired' do
            post '/api/v1/users/reset_password', 
              email: user.email,
              code: user.reset_password_token,
              password: Faker::Internet.password(8)
            expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:reset_password_code_expired])
            expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:forbidden])
          end

        end

      end

    end

    describe '/logout' do

      it 'logs out a valid user' do
        post '/api/v1/users/logout', 
          api_key: user.api_key
        expect(response).to be_success
      end

      it 'returns unauthorized with unexisting api_key' do
        post '/api/v1/users/logout', 
          api_key: Faker::Internet.password(8)
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:unauthorized])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:unauthorized])
      end

      it 'returns not_found for non existing id' do

        get '/api/v1/users/show', 
          api_key: user.api_key,
          id: user.id + 1
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
      end

    end

  end

  describe '/create' do

    it 'creates an user with google provider and without email' do
      post '/api/v1/users/create', 
        provider_name: 'google_oauth2',
        provider_uid: Faker::Lorem.characters(10),
        provider_token: Faker::Lorem.characters(10),
        network_type: network_type,
        ip: ip,
        ssid: ssid,
        device_unique_identifier: Faker::Lorem.unique.characters(10),
        mobile_operating_system_name: Faker::Company.name, 
        mobile_operating_system_version_name: Faker::App.version,
        device_manufacturer_name: Faker::Company.name,
        device_model_name: Faker::Company.name
      expect(response).to be_success
      expect_json_types('user', JsonSchemas::USER)
    end

    it 'creates an user with google provider and with email and image' do
      email = Faker::Internet.email
      post '/api/v1/users/create', 
        provider_name: 'google_oauth2',
        provider_uid: Faker::Lorem.characters(10),
        provider_token: Faker::Lorem.characters(10),
        email: email,
        image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/default.jpg", "image/jpeg"),
        network_type: network_type,
        ip: ip,
        ssid: ssid,
        device_unique_identifier: Faker::Lorem.unique.characters(10),
        mobile_operating_system_name: Faker::Company.name, 
        mobile_operating_system_version_name: Faker::App.version,
        device_manufacturer_name: Faker::Company.name,
        device_model_name: Faker::Company.name
      expect(response).to be_success
      expect_json_types('user', JsonSchemas::USER)
      created_user = User.last
      expect(created_user.email).to eq(email)
      expect(created_user.image.exists?).to be_truthy
    end

    it 'creates an user with google provider and with email and image_url' do
      email = Faker::Internet.email
      post '/api/v1/users/create', 
        provider_name: 'google_oauth2',
        provider_uid: Faker::Lorem.characters(10),
        provider_token: Faker::Lorem.characters(10),
        email: email,
        image_url: 'https://fakeimg.pl/100/',
        network_type: network_type,
        ip: ip,
        ssid: ssid,
        device_unique_identifier: Faker::Lorem.unique.characters(10),
        mobile_operating_system_name: Faker::Company.name, 
        mobile_operating_system_version_name: Faker::App.version,
        device_manufacturer_name: Faker::Company.name,
        device_model_name: Faker::Company.name
      expect(response).to be_success
      expect_json_types('user', JsonSchemas::USER)
      created_user = User.last
      expect(created_user.email).to eq(email)
      expect(created_user.image.exists?).to be_truthy
    end

    it 'should not allow to set both image and image_url' do
      email = Faker::Internet.email
      post '/api/v1/users/create', 
        provider_name: 'google_oauth2',
        provider_uid: Faker::Lorem.characters(10),
        provider_token: Faker::Lorem.characters(10),
        email: email,
        image: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/default.jpg", "image/jpeg"),
        image_url: 'https://fakeimg.pl/100/',
        network_type: network_type,
        ip: ip,
        ssid: ssid,
        device_unique_identifier: Faker::Lorem.unique.characters(10),
        mobile_operating_system_name: Faker::Company.name, 
        mobile_operating_system_version_name: Faker::App.version,
        device_manufacturer_name: Faker::Company.name,
        device_model_name: Faker::Company.name
      expect(response).to_not be_success
    end

  end

end