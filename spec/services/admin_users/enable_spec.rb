require "rails_helper"

describe AdminUsers::Enable do

  subject { AdminUsers::Enable }

  context 'when an disabled admin_user exists' do
    
    before(:each) do
      @admin_user = create(:admin_user, state: 'disabled')
    end

    describe 'call' do

      it 'enables the admin_user' do
        subject.call(admin_user: @admin_user)
        expect(@admin_user).to have_state(:enabled)
      end

    end

  end

  context 'when an enabled admin_user exists' do
    
    before(:each) do
      @admin_user = create(:admin_user, state: 'enabled')
    end

    describe 'call' do

      it 'does nothing with the admin_user' do
        subject.call(admin_user: @admin_user)
        expect(@admin_user).to have_state(:enabled)
      end

    end

  end

end