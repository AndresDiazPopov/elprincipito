require "rails_helper"

describe AdminUsers::Find do

  subject { AdminUsers::Find }

  context 'when no admin_user exists' do

    describe 'call' do

      it 'raises Exceptions::NotFoundError when trying to find unexistent admin_user' do
        expect{
          subject.call(id: Faker::Number.number(1))
          }.to raise_error(Exceptions::NotFoundError)
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
          subject.call(id: @admin_user.id)
          ).to eq(@admin_user)
      end

    end

  end

end