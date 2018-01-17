require "rails_helper"

describe Logins::Search do

  subject { Logins::Search }

  context 'when no logins exists' do

    describe 'call' do

      it 'returns empty array' do
        expect(
          subject.call
          ).to match_array([])
      end

    end

  end

  context 'when multiple logins exist' do

    let(:logins) { create_list(:login, 26) }

    describe 'call' do

      it 'returns paginated logins' do
        expect(
          subject.call
          ).to match_array(Login.all)
      end

    end

  end

  context 'when multiple logins of multiple users exist' do

    let(:users) { create_list(:user, 10) }
    let(:logins) { {} }
    
    before(:each) do
      users.each do |user|
        logins[user.email] = create_list(:login, 5, user: user)
      end
    end

    describe 'call' do

      it 'returns only logins for the specified user' do
        selected_user = users.sample
        
        result = subject.call(user: selected_user)
        expect(result.count).to eq(5)

        result.each do |login|
          expect(login.user).to eq(selected_user)
        end
        
      end

    end

  end

  context 'when multiple logins, with different states, exist' do
    
    let(:login_list_1) { create_list(:login, 5, state: :requested) }
    let(:login_list_2) { create_list(:login, 5, state: :authorized) }
    let(:login_list_3) { create_list(:login, 5, state: :denied) }

    it 'returns only requested logins if specified' do
      
      result = subject.call(states: [Login.states[:requested]])
      
      result.each do |login|
        expect(login).to have_state(:requested)
      end
      
    end

    it 'returns only authorized logins if specified' do
      
      result = subject.call(states: [Login.states[:authorized]])
      
      result.each do |login|
        expect(login).to have_state(:authorized)
      end
      
    end

    it 'returns only denied logins if specified' do
      
      result = subject.call(states: [Login.states[:denied]])
      
      result.each do |login|
        expect(login).to have_state(:denied)
      end
      
    end

  end

  context 'when multiple logins with multiple devices exist' do
    
    let(:device_1) { create(:device) }
    let(:device_2) { create(:device) }
    let(:device_3) { create(:device) }
    let(:login_list_1) { create_list(:login, 5, device: device_1) }
    let(:login_list_2) { create_list(:login, 5, device: device_2) }
    let(:login_list_3) { create_list(:login, 5, device: device_3) }

    it 'returns only logins of requested device manufacturers' do
      
      result = subject.call(device_manufacturer: device_1.device_model.device_manufacturer)
      
      result.each do |login|
        expect(login.device.device_manufacturer).to eq(device_1.device_model.device_manufacturer)
      end
      
    end

  end

end