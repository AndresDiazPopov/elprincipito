require "rails_helper"

describe AdminRoles::Find do

  subject { AdminRoles::Find }

  context 'when no admin_role exists' do

    describe 'call' do

      it 'raises Exceptions::NotFoundError when trying to find unexistent admin_role' do
        expect{
          subject.call(id: Faker::Number.number(1))
          }.to raise_error(Exceptions::NotFoundError)
      end

    end

  end

  context 'when a admin_role exist' do
    
    before(:each) do
      @admin_role = create(:admin_role)
    end

    describe 'call' do

      it 'returns the admin_role' do
        expect(
          subject.call(id: @admin_role.id)
          ).to eq(@admin_role)
      end

    end

  end

end