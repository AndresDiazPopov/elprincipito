require "rails_helper"

describe Users::Search do

  subject { Users::Search }

  context 'when no users exists' do

    describe 'call' do

      it 'returns empty array' do
        expect(
          subject.call
          ).to match_array([])
      end

    end

  end

  context 'when multiple users exist' do
    
    before(:each) do
      @users = create_list(:user, 26)
    end

    describe 'call' do

      it 'returns paginated users' do
        expect(
          subject.call
          ).to match_array(User.all)
      end

    end

  end

  context 'when two different emailed users sets exist' do
    
    before(:each) do
      @users1 = []
      @users2 = []
      10.times do |index|
        user1 = create(:user, email: "email#{index.to_s}@example.com")
        @users1 << user1
        user2 = create(:user, email: "correo#{index.to_s}@ejemplo.com")
        @users2 << user2
      end
    end

    describe 'call' do

      it 'returns only users that match the searched text for set 1' do
        expect(
          subject.call(text: "email")
          ).to match_array(@users1)
      end

      it 'returns only users that match the searched text for set 2' do
        expect(
          subject.call(text: "correo")
          ).to match_array(@users2)
      end

      it 'searches ignoring case' do
        expect(
          subject.call(text: "EMAIL")
          ).to match_array(@users1)
      end

    end

  end

end