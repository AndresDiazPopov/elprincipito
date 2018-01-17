require "rails_helper"

describe AdminUsers::Disable do

  subject { AdminUsers::Disable }

  context 'when an disabled admin_user exists' do
    
    before(:each) do
      @admin_user = create(:admin_user, state: 'enabled')
    end

    describe 'call' do

      it 'disables the admin_user' do
        subject.call(admin_user: @admin_user)
        expect(@admin_user).to have_state(:disabled)
      end

    end

  end

  context 'when an disabled admin_user exists' do
    
    before(:each) do
      @admin_user = create(:admin_user, state: 'disabled')
    end

    describe 'call' do

      it 'does nothing with the admin_user' do
        subject.call(admin_user: @admin_user)
        expect(@admin_user).to have_state(:disabled)
      end

    end

  end

end