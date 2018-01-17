require "rails_helper"

describe Users::Delete do

  subject { Users::Delete }

  context 'when a user exists' do
    
    before(:each) do
      @user = create(:user)
    end

    describe 'call' do

      it 'deletes the user' do
        subject.call(
          user: @user)
        expect(User.exists?(email: @user.email)).to be_falsy
      end

    end

  end

end