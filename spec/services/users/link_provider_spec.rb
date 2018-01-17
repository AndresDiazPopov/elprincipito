require "rails_helper"

describe Users::LinkProvider do

  subject { Users::LinkProvider }

  context 'when a user exists' do
    
    before(:each) do
      @user = create(:user)
    end

    describe 'call' do

      context 'when user does not have any identity providers' do

        it 'links the user to the facebook provider' do
          expect{
            subject.call(
              user: @user,
              provider_name: 'facebook',
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10))
            }.to change{@user.identities.count}.from(0).to(1)
        end

        it 'links the user to the twitter provider' do
          expect{
            subject.call(
              user: @user,
              provider_name: 'twitter',
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10),
              provider_token_secret: Faker::Lorem.characters(10))
            }.to change{@user.identities.count}.from(0).to(1)
        end

        it 'links the user to the google_oauth2 provider' do
          expect{
            subject.call(
              user: @user,
              provider_name: 'google_oauth2',
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10))
            }.to change{@user.identities.count}.from(0).to(1)
        end

      end

      context 'when user has one identity provider' do

        before(:each) do
          @user.identities = [build(:identity, :google_oauth2)]
          @user.save
        end

        it 'links the user to another provider' do
          expect{
            subject.call(
              user: @user,
              provider_name: 'twitter',
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10),
              provider_token_secret: Faker::Lorem.characters(10))
            }.to change{@user.identities.count}.from(1).to(2)
          expect{
            subject.call(
              user: @user,
              provider_name: 'facebook',
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10))
            }.to change{@user.identities.count}.from(2).to(3)
        end

        it 'raises Exceptions::DuplicatedEntityError when trying to link to an existing provider' do
          expect{
            subject.call(
              user: @user,
              provider_name: @user.identities.first.provider,
              provider_uid: Faker::Lorem.characters(10),
              provider_token: Faker::Lorem.characters(10))
            }.to raise_error(Exceptions::DuplicatedEntityError)
        end

        context 'when another user exists' do

          before(:each) do
            @user2 = create(:user)
          end

          it 'raises Exceptions::AlreadyLinkedToAnotherUserError when trying to link to the same provider account that the other user' do
            expect{
              subject.call(
                user: @user2,
                provider_name: @user.identities.first.provider,
                provider_uid: @user.identities.first.uid,
                provider_token: Faker::Lorem.characters(10))
              }.to raise_error(Exceptions::AlreadyLinkedToAnotherUserError)
          end

        end

      end

    end

  end

end