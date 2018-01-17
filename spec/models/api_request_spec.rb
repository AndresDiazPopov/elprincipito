require 'rails_helper'

RSpec.describe ApiRequest, type: :model do

  it 'allows api_request without user' do
    api_request = build(:api_request, user: nil)
    expect(api_request).to be_valid
  end

  it 'allows api_request without login' do
    api_request = build(:api_request, login: nil)
    expect(api_request).to be_valid
  end

  it 'does not allow api_request without path' do
    api_request = build(:api_request, path: nil)
    expect(api_request).not_to be_valid
  end

  it 'does not allow api_request without params' do
    api_request = build(:api_request, params: nil)
    expect(api_request).not_to be_valid
  end

  it 'does not allow api_request without ip' do
    api_request = build(:api_request, ip: nil)
    expect(api_request).not_to be_valid
  end
  
  it 'allow api_request without network_type' do
    api_request = build(:api_request, network_type: nil)
    expect(api_request).to be_valid
  end

  ApiRequest.network_types.values.sample do |network_type|

    it "allow api_request with network_type: #{network_type}" do
      api_request = build(:api_request, network_type: network_type)
      expect(api_request).to be_valid
    end

  end
  
  it 'does not save api_request with invalid network_type' do
    expect {
      build(:api_request, network_type: ApiRequest.network_types.values.max + 1)
      }.to raise_error(ArgumentError)
  end

end
