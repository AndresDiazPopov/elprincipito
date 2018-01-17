require "rails_helper"

describe ApiRequests::Search do

  subject { ApiRequests::Search }

  context 'when no api_request exists' do

    describe 'call' do

      it 'returns empty array' do
        expect(
          subject.call
          ).to match_array([])
      end

    end

  end

  context 'when multiple api_requests exist' do

    let(:api_requests) { create_list(:api_request, 26) }

    describe 'call' do

      it 'returns paginated api_requests' do
        expect(
          subject.call
          ).to match_array(ApiRequest.all)
      end

    end

  end

  context 'when multiple api_requests of multiple users exist' do

    let(:users) { create_list(:user, 10) }
    let(:api_requests) { {} }
    
    before(:each) do
      users.each do |user|
        api_requests[user.email] = create_list(:api_request, 5, user: user)
      end
    end

    describe 'call' do

      it 'returns only api_requests for the specified user' do
        selected_user = users.sample
        
        result = subject.call(user: selected_user)
        expect(result.count).to eq(5)

        result.each do |api_request|
          expect(api_request.user).to eq(selected_user)
        end
        
      end

    end

  end

  context 'when multiple api_requests of multiple logins exist' do

    let(:logins) { create_list(:login, 10) }
    let(:api_requests) { {} }
    
    before(:each) do
      logins.each do |login|
        api_requests[login.id.to_s] = create_list(:api_request, 5, login: login)
      end
    end

    describe 'call' do

      it 'returns only api_requests for the specified login' do
        selected_login = logins.sample
        
        result = subject.call(login: selected_login)
        expect(result.count).to eq(5)

        result.each do |api_request|
          expect(api_request.login).to eq(selected_login)
        end
        
      end

    end

  end

end