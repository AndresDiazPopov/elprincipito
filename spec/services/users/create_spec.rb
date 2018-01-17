require "rails_helper"

describe Users::Create do

  subject { Users::Create }
  
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

    context 'when the user has an identity' do

      let(:identity) { create(:identity, :google_oauth2, user: user) }

      describe 'call' do

        it 'raises Exceptions::DuplicatedEntityError exception when creating another user with the same provider and uid' do
          expect{
            subject.call(
              provider_name: identity.provider, 
              provider_uid: identity.uid, 
              provider_token: Faker::Lorem.characters(10),
              login_params: login_params,
              device_params: device_params)
          }.to raise_error(Exceptions::DuplicatedEntityError)
        end

      end

    end

    describe 'call' do

      it 'creates and returns the created user when passing unexisting email and an image' do
        email = Faker::Internet.email
        expect(
          subject.call(
            email: email, 
            password: Faker::Internet.password(8),
            image: File.new("#{Rails.root}/spec/support/default.jpg"),
            login_params: login_params,
            device_params: device_params)[0]
        ).to eq(User.find_by(email: email))
      end

      it 'creates an authorized login' do
        email = Faker::Internet.email
        expect{
          subject.call(
            email: email, 
            password: Faker::Internet.password(8),
            image: File.new("#{Rails.root}/spec/support/default.jpg"),
            login_params: login_params,
            device_params: device_params)
        }.to change{Login.authorized.count}.by(1)
      end

      it 'creates and returns the created user when passing unexisting email and an image url' do
        email = Faker::Internet.email
        expect(
          subject.call(
            email: email, 
            password: Faker::Internet.password(8),
            image_url: 'https://fakeimg.pl/100/',
            login_params: login_params,
            device_params: device_params)[0]
        ).to eq(User.find_by(email: email))
        user = User.find_by(email: email)
        expect(user.reload.image.exists?).to be_truthy
      end

      it 'creates and returns the created user when passing unexisting email and an url-encoded image url' do
        email = Faker::Internet.email
        expect(
          subject.call(
            email: email, 
            password: Faker::Internet.password(8),
            image_url: 'https%3A%2F%2Ffakeimg.pl%2F100%2F',
            login_params: login_params,
            device_params: device_params)[0]
        ).to eq(User.find_by(email: email))
        user = User.find_by(email: email)
        expect(user.reload.image.exists?).to be_truthy
      end

      it 'creates and returns the created user when passing unexisting email' do
        email = Faker::Internet.email
        expect(
          subject.call(
            email: email, 
            password: Faker::Internet.password(8),
            login_params: login_params,
            device_params: device_params)[0]
        ).to eq(User.find_by(email: email))
      end

      it 'creates and returns the created user when passing unexisting email' do
        email = Faker::Internet.email
        expect(
          subject.call(
            email: email, 
            password: Faker::Internet.password(8),
            login_params: login_params,
            device_params: device_params)[0]
        ).to eq(User.find_by(email: email))
      end

      it 'raises Exceptions::DuplicatedEntityError exception when passing existing email' do
        expect{
          subject.call(email: user.email,
            login_params: login_params,
            device_params: device_params)
        }.to raise_error(Exceptions::DuplicatedEntityError)
      end

    end

  end

  context 'when no user exists' do

    describe 'call' do

      it "creates a user with email and password" do
        email = Faker::Internet.email
        expect(
          subject.call(
            email: email,
            password: Faker::Internet.password(8),
            login_params: login_params,
            device_params: device_params)[0]
          ).to eq(User.find_by(email: email))
      end

      it "creates a user with email and password and image" do
        email = Faker::Internet.email
        expect(
          subject.call(
            email: email,
            password: Faker::Internet.password(8),
            image: File.new("#{Rails.root}/spec/support/default.jpg"),
            login_params: login_params,
            device_params: device_params)[0]
          ).to eq(User.find_by(email: email))
      end

      it "creates a user with email and password and image_url" do
        email = Faker::Internet.email
        expect(
          subject.call(
            email: email,
            password: Faker::Internet.password(8),
            image_url: 'https://fakeimg.pl/100/',
            login_params: login_params,
            device_params: device_params)[0]
          ).to eq(User.find_by(email: email))
      end

      it "creates a user with email and password and image" do
        email = Faker::Internet.email
        expect(
          subject.call(
            email: email,
            password: Faker::Internet.password(8),
            image: File.new("#{Rails.root}/spec/support/default.jpg"),
            login_params: login_params,
            device_params: device_params)[0]
          ).to eq(User.find_by(email: email))
      end

      it "correctly sets the image passed as parameter" do
        email = Faker::Internet.email
        subject.call(
          email: email,
          password: Faker::Internet.password(8),
          image: File.new("#{Rails.root}/spec/support/default.jpg"),
          login_params: login_params,
            device_params: device_params)
        expect(User.find_by(email: email).image.exists?).to be_truthy
      end

      it "creates a user with email, password and twitter provider" do
        email = Faker::Internet.email
        uid = Faker::Lorem.characters(10)
        token = Faker::Lorem.characters(10)
        token_secret = Faker::Lorem.characters(10)
        expect(
          subject.call(
            email: email,
            password: Faker::Internet.password(8),
            provider_name: 'twitter',
            provider_uid: uid,
            provider_token: token,
            provider_token_secret: token_secret,
            login_params: login_params,
            device_params: device_params)[0]
          ).to eq(User.find_by(email: email))
        expect(User.find_by(email: email).identities.first.provider).to eq('twitter')
        expect(User.find_by(email: email).identities.first.uid).to eq(uid)
        expect(User.find_by(email: email).identities.first.token).to eq(token)
        expect(User.find_by(email: email).identities.first.token_secret).to eq(token_secret)
      end

      it "creates a user with email, password and facebook provider" do
        email = Faker::Internet.email
        uid = Faker::Lorem.characters(10)
        token = Faker::Lorem.characters(10)
        expect(
          subject.call(
            email: email,
            password: Faker::Internet.password(8),
            provider_name: 'facebook',
            provider_uid: uid,
            provider_token: token,
            login_params: login_params,
            device_params: device_params)[0]
          ).to eq(User.find_by(email: email))
        expect(User.find_by(email: email).identities.first.provider).to eq('facebook')
        expect(User.find_by(email: email).identities.first.uid).to eq(uid)
        expect(User.find_by(email: email).identities.first.token).to eq(token)
      end

      it "creates a user with email, password and google_oauth2 provider" do
        email = Faker::Internet.email
        uid = Faker::Lorem.characters(10)
        token = Faker::Lorem.characters(10)
        expect(
          subject.call(
            email: email,
            password: Faker::Internet.password(8),
            provider_name: 'google_oauth2',
            provider_uid: uid,
            provider_token: token,
            login_params: login_params,
            device_params: device_params)[0]
          ).to eq(User.find_by(email: email))
        expect(User.find_by(email: email).identities.first.provider).to eq('google_oauth2')
        expect(User.find_by(email: email).identities.first.uid).to eq(uid)
        expect(User.find_by(email: email).identities.first.token).to eq(token)
      end

      it "creates a user without email and password but with identity provider" do
        expect{
          subject.call(
            provider_name: 'facebook',
            provider_uid: Faker::Lorem.characters(10),
            provider_token: Faker::Lorem.characters(10),
            login_params: login_params,
            device_params: device_params)
          }.to change{User.count}.from(0).to(1)
      end

      it "creates two users without email and password but with identity provider" do
        expect{
          subject.call(
            provider_name: 'facebook',
            provider_uid: Faker::Lorem.characters(10),
            provider_token: Faker::Lorem.characters(10),
            login_params: login_params,
            device_params: device_params)
          subject.call(
            provider_name: 'facebook',
            provider_uid: Faker::Lorem.characters(10),
            provider_token: Faker::Lorem.characters(10),
            login_params: login_params,
            device_params: device_params)
          }.to change{User.count}.from(0).to(2)
      end

      it 'creates a denied login when validation error occur' do
        expect{
          subject.call(
            provider_name: 'facebfdsaook',
            provider_uid: Faker::Lorem.characters(10),
            provider_token: Faker::Lorem.characters(10),
            login_params: login_params,
            device_params: device_params)
        }.to change{Login.denied.count}.by(1)
      end

      context 'when an unexpired app_version exists' do

        let!(:app_version) { create(:app_version, expired_at: nil) }

        before(:each) do
          login_params[:app_version_name] = app_version.name
        end

        it 'creates an authorized login' do
          expect{
            subject.call(
              email: Faker::Internet.email, 
              password: Faker::Internet.password(8),
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
              email: Faker::Internet.email, 
              password: Faker::Internet.password(8),
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
              email: Faker::Internet.email, 
              password: Faker::Internet.password(8),
              login_params: login_params,
              device_params: device_params) rescue nil
          }.to change{Login.denied.count}.by(1)
        end

        it 'raises Exceptions::AppVersionExpired when using an unexisting api_key' do
          expect{
            subject.call(
              email: Faker::Internet.email, 
              password: Faker::Internet.password(8),
              login_params: login_params,
              device_params: device_params)
            }.to raise_error(Exceptions::AppVersionExpiredError)
        end

      end

    end

  end

end