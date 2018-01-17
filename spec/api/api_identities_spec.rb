require "rails_helper"

describe '/identities' do
  
  context 'when an identity exists' do
    
    before(:each) do
      @user = create(:user)
      @identity = create(:identity, :google_oauth2, user: @user)
    end

    describe '/create' do

      it 'does not create an identity with a provider already linked to a user' do
        post '/api/v1/identities/create', 
          api_key: @user.api_key, 
          provider_name: @identity.provider, 
          provider_uid: Faker::Lorem.characters(10), 
          provider_token: Faker::Lorem.characters(10)
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:already_exists])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:conflict])
      end

    end

    describe '/delete' do

      it 'deletes an identity with an existing provider' do
        post '/api/v1/identities/delete', 
          api_key: @user.api_key, 
          provider_name: @identity.provider
        expect(response).to be_success
        expect_private_user
        expect(@user.identities.count).to eq(0)
      end

      it 'does not delete an identity with a provider not linked to a user' do
        post '/api/v1/identities/delete', 
          api_key: @user.api_key, 
          provider_name: :twitter
        expect(response).to have_exception_code(API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found])
        expect(response.status).to eq(API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
      end

    end

  end

  describe '/create' do

    it "creates a valid identity" do
      user = create(:user)
      post '/api/v1/identities/create', 
        api_key: user.api_key, 
        provider_name: 'google_oauth2', 
        provider_uid: Faker::Lorem.characters(10), 
        provider_token: Faker::Lorem.characters(10)
      expect(response).to be_success
      expect_private_user
    end

  end

end