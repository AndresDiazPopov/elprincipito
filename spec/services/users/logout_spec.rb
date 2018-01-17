require "rails_helper"

describe Users::Logout do

  subject { Users::Logout }

  context 'when a user exists' do
    
    before(:each) do
      @user = create(:user)
    end

    describe 'call' do

      it 'logs out the user' do
        subject.call(
          user: @user)
        # Compruebo que el usuario siga existiendo
        expect(User.exists?(email: @user.email)).to be_truthy
      end

    end

  end

end