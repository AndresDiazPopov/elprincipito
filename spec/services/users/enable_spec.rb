require "rails_helper"

describe Users::Enable do

  subject { Users::Enable }

  context 'when an disabled user exists' do
    
    before(:each) do
      @user = create(:user, state: 'disabled')
    end

    describe 'call' do

      it 'enables the user' do
        subject.call(user: @user)
        expect(@user).to have_state(:enabled)
      end

    end

  end

  context 'when an enabled user exists' do
    
    before(:each) do
      @user = create(:user, state: 'enabled')
    end

    describe 'call' do

      it 'does nothing with the user' do
        subject.call(user: @user)
        expect(@user).to have_state(:enabled)
      end

    end

  end

end