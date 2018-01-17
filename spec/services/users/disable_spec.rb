require "rails_helper"

describe Users::Disable do

  subject { Users::Disable }

  context 'when an disabled user exists' do
    
    before(:each) do
      @user = create(:user, state: 'enabled')
    end

    describe 'call' do

      it 'disables the user' do
        subject.call(user: @user)
        expect(@user).to have_state(:disabled)
      end

    end

  end

  context 'when an disabled user exists' do
    
    before(:each) do
      @user = create(:user, state: 'disabled')
    end

    describe 'call' do

      it 'does nothing with the user' do
        subject.call(user: @user)
        expect(@user).to have_state(:disabled)
      end

    end

  end

end