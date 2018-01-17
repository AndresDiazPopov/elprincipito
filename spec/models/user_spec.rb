require "rails_helper"

describe User do

  context 'when a user exists' do
    
    before(:each) do
      @user = create(:user)
    end

    it 'does not allow duplicated emails' do
      user_2 = build(:user, email: @user.email)
      expect(user_2).to_not be_valid
    end

    it 'does not allow duplicated api keys' do
      user_2 = build(:user, api_key: @user.api_key)
      expect(user_2).to_not be_valid
    end

  end

  it 'saves a user with email and password' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'saves a user with email and password and image' do
    user = build(:user, image: File.new("#{Rails.root}/spec/support/default.jpg"))
    expect(user).to be_valid
  end

  it 'autogenerates api keys if nil' do
    user = build(:user, api_key: nil)
    user.save
    expect(user.api_key).to_not be_nil
  end

  it 'allow user with empty emails and password' do
    user = build(:user, email: nil, password: nil, identities: [build(:identity)])
    expect(user).to be_valid
  end

  it 'do not allow empty emails when user has password' do
    user = build(:user, email: nil, identities: [build(:identity)])
    expect(user).to_not be_valid
  end

  it 'should allow empty passwords even when user has email' do
    user = build(:user, password: nil, identities: [build(:identity)])
    expect(user).to be_valid
  end

  it 'allows multiple users with empty emails and password' do
    user = create(:user, email: nil, password: nil, identities: [build(:identity)])
    expect(user).to be_valid
    user2 = create(:user, email: nil, password: nil, identities: [build(:identity)])
    expect(user2).to be_valid
  end

  describe 'state transitions' do

    let(:user) { create(:user, state: 'enabled') }

    it 'transitions from enabled to disabled' do
      expect(user).to transition_from(:enabled).to(:disabled).on_event(:disable)
    end

    it 'transitions from disabled to enabled' do
      expect(user).to transition_from(:disabled).to(:enabled).on_event(:enable)
    end

  end

end