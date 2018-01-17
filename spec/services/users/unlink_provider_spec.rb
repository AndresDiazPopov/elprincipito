require "rails_helper"

describe Users::UnlinkProvider do

  subject { Users::UnlinkProvider }

  context 'when a user exists' do
    
    before(:each) do
      @user = create(:user)
    end

    describe 'call' do

      context 'when user does not have any identity providers' do

        it 'raises Exceptions::NotFoundError when trying to unlink from unexisting provider' do
          expect{
            subject.call(
              user: @user,
              provider_name: Faker::Lorem.word)
            }.to raise_error(Exceptions::NotFoundError)
        end

      end

      context 'when user has one identity provider' do

        before(:each) do
          @user.identities = [build(:identity, :google_oauth2)]
          @user.save
        end

        it 'unlinks the provider from the user' do
          expect{
            subject.call(
              user: @user,
              provider_name: @user.identities.first.provider)
            }.to change{@user.identities.count}.from(1).to(0)
        end

        it 'raises Exceptions::NotFoundError when trying to unlink from unexisting provider' do
          expect{
            subject.call(
              user: @user,
              provider_name: Faker::Lorem.word)
            }.to raise_error(Exceptions::NotFoundError)
        end

        context 'when user does not have email and password' do

          before(:each) do
            @user.update_attributes(email: nil, password: nil)
          end

          it 'raises Exceptions::OnlyLinkedToThisProviderError when trying to unlink from unexisting provider' do
            expect{
              subject.call(
                user: @user,
                provider_name: @user.identities.first.provider)
              }.to raise_error(Exceptions::OnlyLinkedToThisProviderError)
          end

        end

      end

    end

  end

end