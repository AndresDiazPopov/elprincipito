require "rails_helper"

describe Users::RequestPasswordResetInstructions do

  subject { Users::RequestPasswordResetInstructions }

  context 'when a user exists' do
    
    before(:each) do
      @user = create(:user)
    end

    describe 'call' do

      it 'does not raise exception when passing existing email' do
        expect{
          subject.call(
            email: @user.email)
          }.to_not raise_error
      end

      it 'sets reset_password_token when passing existing email' do
        expect{
          subject.call(email: @user.email)
          }.to change{@user.reload.reset_password_token}
      end

      it 'sets reset_password_sent_at when passing existing email' do
        expect{
          subject.call(email: @user.email)
          }.to change{@user.reload.reset_password_sent_at}.from(nil)
      end

      it 'raises Exceptions::NotFoundError when passing unexisting email' do
        expect{
          subject.call(
            email: Faker::Internet.email)
          }.to raise_error(Exceptions::NotFoundError)
      end

      it 'sends the mail to the user' do
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(0)
        subject.call(email: @user.email)
        expect(Sidekiq::Extensions::DelayedMailer.jobs.size).to eq(1)
      end

    end

  end

end