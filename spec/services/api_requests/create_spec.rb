require "rails_helper"

describe ApiRequests::Create do

  subject { ApiRequests::Create }

  context 'when no api_requests exists' do

    describe 'call' do

      it 'creates a valid api_request' do
        expect(
          subject.call(api_request_params: {
            path: Faker::Internet.url('')[7..-1],
            params: Faker::Lorem.word,
            network_type: ApiRequest.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word})
          ).to eq(ApiRequest.last)
      end

      it 'creates a valid api_request with user' do
        expect(
          subject.call(api_request_params: {
            user: create(:user),
            path: Faker::Internet.url('')[7..-1],
            params: Faker::Lorem.word,
            network_type: ApiRequest.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word})
          ).to eq(ApiRequest.last)
      end

      it 'creates a valid api_request with login' do
        expect(
          subject.call(api_request_params: {
            login: create(:login),
            path: Faker::Internet.url('')[7..-1],
            params: Faker::Lorem.word,
            network_type: ApiRequest.network_types.keys.sample,
            ip: Faker::Internet.public_ip_v4_address,
            ssid: Faker::Lorem.word})
          ).to eq(ApiRequest.last)
      end

    end

  end

end