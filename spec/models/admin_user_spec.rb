require "rails_helper"

describe AdminUser do

  context 'when an admin_user exists' do
    
    before(:each) do
      @admin_user = create(:admin_user)
    end

    it 'does not allow duplicated emails' do
      admin_user_2 = build(:admin_user, email: @admin_user.email)
      expect(admin_user_2).to_not be_valid
    end

    it 'allows multiple admin_users' do
      admin_user_2 = build(:admin_user)
      expect(admin_user_2).to be_valid
    end

  end

  it 'does not allow empty emails' do
    admin_user = build(:admin_user, email: nil)
    expect(admin_user).to_not be_valid
  end

  it 'do not allow empty passwords' do
    admin_user = build(:admin_user, password: nil)
    expect(admin_user).to_not be_valid
  end

  it 'do not allow empty full_name' do
    admin_user = build(:admin_user, full_name: nil)
    expect(admin_user).to_not be_valid
  end

  it 'saves an admin with email and password' do
    admin_user = build(:admin_user)
    expect(admin_user).to be_valid
  end

  describe 'state transitions' do
    before(:each) do
      @admin_user = create(:admin_user, state: 'enabled')
    end

    it 'transitions from enabled to disabled' do
      expect(@admin_user).to transition_from(:enabled).to(:disabled).on_event(:disable)
    end

    it 'transitions from disabled to enabled' do
      expect(@admin_user).to transition_from(:disabled).to(:enabled).on_event(:enable)
    end

  end

end