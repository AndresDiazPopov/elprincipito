require "rails_helper"

describe Users::ResetPassword do

  subject { Users::ResetPassword }

  context 'when a user exists' do
    
    before(:each) do
      @user = create(:user)
    end

    describe 'call' do

      context 'when the user did not requested password reset instructions' do

        it 'raises Exceptions::NotFoundError when passing existing email' do
          expect{
            subject.call(
              email: Faker::Internet.email,
              code: Faker::Number.number(4),
              password: Faker::Internet.password(8))
            }.to raise_error(Exceptions::NotFoundError)
        end

      end

      context 'when the user requested password reset instructions' do

        before(:each) do
          Users::RequestPasswordResetInstructions.call(email: @user.email)
          @user.reload
        end

        it 'changes the password when passing existing email' do
          expect{
            subject.call(
              email: @user.email,
              code: @user.reset_password_token,
              password: Faker::Internet.password(8))
            }.to change{@user.reload.encrypted_password}
        end

        it 'sets the new password when passing existing email' do
          old_password = @user.password
          password = Faker::Internet.password(8)
          subject.call(
            email: @user.email,
            code: @user.reset_password_token,
            password: password)
          expect(@user.reload.valid_password?(old_password)).to be_falsy
          expect(@user.reload.valid_password?(password)).to be_truthy
        end

        it 'raises Exceptions::NotFoundError when passing wrong code' do
          expect{
            subject.call(
              email: @user.email,
              code: Faker::Number.number(4),
              password: Faker::Internet.password(8))
            }.to raise_error(Exceptions::NotFoundError)
        end

        context 'when the reset password token is expired' do

          before(:each) do
            @user.update_attributes(reset_password_sent_at: 1.year.ago)
          end

          it 'raises Exceptions::ResetPasswordCodeExpiredError when trying to reset password' do
            expect{
              subject.call(
                email: @user.email,
                code: @user.reset_password_token,
                password: Faker::Internet.password(8))
              }.to raise_error(Exceptions::ResetPasswordCodeExpiredError)
          end

        end

      end

      it 'raises Exceptions::NotFoundError when passing unexisting email' do
        expect{
          subject.call(
            email: Faker::Internet.email,
            code: Faker::Number.number(4),
            password: Faker::Internet.password(8))
          }.to raise_error(Exceptions::NotFoundError)
      end

    end

  end

end