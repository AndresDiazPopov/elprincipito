require "rails_helper"

describe Identity do

  context 'when an identity exists' do
    
    before(:each) do
      @identity = create(:identity, :google_oauth2)
    end

    it 'does not save identity with duplicated provider and uid' do
      identity_2 = build(:identity, provider: @identity.provider, uid: @identity.uid)
      expect(identity_2).to_not be_valid
    end

    it 'does not save identity with existing provider for same user' do
      identity_2 = build(:identity, provider: @identity.provider, user: @identity.user)
      expect(identity_2).to_not be_valid
    end

    it 'saves identity with existing provider but for different user' do
      identity_2 = build(:identity, provider: @identity.provider)
      expect(identity_2).to be_valid
    end

  end

  it 'does not save identity without user' do
    identity = build(:identity, user: nil)
    expect(identity).to_not be_valid
  end

  it 'does not save identity without provider' do
    identity = build(:identity, provider: nil)
    expect(identity).to_not be_valid
  end

  it 'does not save identity without uid' do
    identity = build(:identity, uid: nil)
    expect(identity).to_not be_valid
  end

  it 'does not save identity without token' do
    identity = build(:identity, token: nil)
    expect(identity).to_not be_valid
  end

  # it 'does not save twitter identity without token_secret' do
  #   identity = build(:identity, :twitter, token_secret: nil)
  #   expect(identity).to_not be_valid
  # end

  it 'does not save identity with provider not facebook, twitter or google_oauth2' do
    identity = build(:identity, provider: Faker::Lorem.word)
    expect(identity).to_not be_valid
  end

  it 'saves valid identity' do
    identity = build(:identity)
    expect(identity).to be_valid
  end

  # it 'should delete an identity of an user which does not have email but has more than one identity' do
  #   identity_1 = build(:identity)
  #   identity_2 = build(:identity)
  #   user = create(:user, identities: [identity_1, identity_2])
  #   expect { identity_1.destroy }.to change { Identity.count }.by(-1)
  # end

  # it 'should not delete the only identity of an user which does not have email' do
  #   identity = build(:identity)
  #   user = create(:user, email: nil, identities: [identity])
  #   expect { identity.destroy }.to_not change { Identity.count }
  # end

  # it 'should not delete the only identity of an user which does not have password' do
  #   identity = build(:identity)
  #   user = create(:user, password: nil, identities: [identity])
  #   expect { identity.destroy }.to_not change { Identity.count }
  # end

  # it 'should delete the only identity of an user which has email' do
  #   identity = build(:identity)
  #   user = create(:user, identities: [identity])
  #   expect { identity.destroy }.to change { Identity.count }.by(-1)
  # end

end