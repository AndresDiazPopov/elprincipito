require "rails_helper"

describe AdminUsers::Search do

  subject { AdminUsers::Search }

  context 'when no users exists' do

    describe 'call' do

      it 'returns empty array' do
        expect(
          subject.call
          ).to match_array([])
      end

    end

  end

  context 'when multiple admin_users exist' do
    
    before(:each) do
      @admin_users = create_list(:admin_user, 26)
    end

    describe 'call' do

      it 'returns paginated users' do
        expect(
          subject.call
          ).to match_array(AdminUser.all)
      end

    end

  end

  context 'when two different emailed admin_users sets exist' do
    
    before(:each) do
      @admin_users1 = []
      @admin_users2 = []
      10.times do |index|
        admin_user1 = create(:admin_user, email: "email#{index.to_s}@example.com")
        @admin_users1 << admin_user1
        admin_user2 = create(:admin_user, email: "correo#{index.to_s}@ejemplo.com")
        @admin_users2 << admin_user2
      end
    end

    describe 'call' do

      it 'returns only admin_users that match the searched text for set 1' do
        expect(
          subject.call(text: "email")
          ).to match_array(@admin_users1)
      end

      it 'returns only admin_users that match the searched text for set 2' do
        expect(
          subject.call(text: "correo")
          ).to match_array(@admin_users2)
      end

      it 'searches ignoring case' do
        expect(
          subject.call(text: "EMAIL")
          ).to match_array(@admin_users1)
      end

    end

  end

end