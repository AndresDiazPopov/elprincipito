require 'rails_helper'

RSpec.describe Login, type: :model do

  context 'when a login exists' do

    let!(:login) { create(:login) }

    it 'does not allow duplicated codes' do
      login_2 = build(:login, code: login.code)
      expect(login_2).to_not be_valid
    end

  end

  it 'autogenerates codes if nil' do
    login = build(:login, code: nil)
    login.save
    expect(login.code).to_not be_nil
  end

  it 'allows login without user' do
    login = build(:login, user: nil)
    expect(login).to be_valid
  end

  it 'does not allow login without state' do
    login = build(:login, state: nil)
    expect(login).to_not be_valid
  end

  it 'allow login without latitude' do
    login = build(:login, latitude: nil)
    expect(login).to be_valid
  end

  it 'allow login without longitude' do
    login = build(:login, longitude: nil)
    expect(login).to be_valid
  end
  
  it 'does not save login without ip' do
    login = build(:login, ip: nil)
    expect(login).to_not be_valid
  end
  
  it 'does not save login without network_type' do
    login = build(:login, network_type: nil)
    expect(login).to_not be_valid
  end
  
  it 'does not save login without locale_language' do
    login = build(:login, locale_language: nil)
    expect(login).to_not be_valid
  end
  
  it 'does not save login without locale_country' do
    login = build(:login, locale_country: nil)
    expect(login).to_not be_valid
  end

  Login.network_types.values.sample do |network_type|

    it "allow login with network_type: #{network_type}" do
      login = build(:login, network_type: network_type)
      expect(login).to be_valid
    end

  end
  
  it 'does not save login with invalid network_type' do
    expect {
      build(:login, network_type: Login.network_types.values.max + 1)
      }.to raise_error(ArgumentError)
  end

  describe 'state transitions' do

    let(:login) { create(:login, state: 'requested') }
    
    it 'transitions from requested to authorized' do
      expect(login).to transition_from(:requested).to(:authorized).on_event(:authorize)
    end

    it 'transitions from requested to denied' do
      expect(login).to transition_from(:requested).to(:denied).on_event(:deny)
    end

    it 'does not transition from authorized to denied' do
      login.state = :authorized
      expect(login).to_not allow_transition_to(:denied)
    end

    it 'does not transition from denied to authorized' do
      login.state = :denied
      expect(login).to_not allow_transition_to(:authorized)
    end

  end

end
