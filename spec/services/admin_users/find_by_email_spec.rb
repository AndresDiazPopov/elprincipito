require "rails_helper"

describe AdminUsers::FindByEmail do

  subject { AdminUsers::FindByEmail }

  context 'when no admin_user exists' do

    describe 'call' do

      it 'returns nil when trying to find unexistent admin_user' do
        expect(
          subject.call(email: Faker::Internet.email)
          ).to eq(nil)
      end

    end

  end

  context 'when a admin_user exist' do
    
    before(:each) do
      @admin_user = create(:admin_user)
    end

    describe 'call' do

      it 'returns the admin_user' do
        expect(
          subject.call(email: @admin_user.email)
          ).to eq(@admin_user)
      end

    end

  end

end