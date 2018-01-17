require "rails_helper"

describe Users::Find do

  subject { Users::Find }

  context 'when no user exists' do

    describe 'call' do

      it 'raises Exceptions::NotFoundError when trying to find unexistent user' do
        expect{
          subject.call(id: Faker::Number.number(1))
          }.to raise_error(Exceptions::NotFoundError)
      end

    end

  end

  context 'when a user exist' do
    
    before(:each) do
      @user = create(:user)
    end

    describe 'call' do

      it 'returns the user' do
        expect(
          subject.call(id: @user.id)
          ).to eq(@user)
      end

    end

  end

end