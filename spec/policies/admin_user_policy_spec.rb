require 'rails_helper'

RSpec.describe AdminUserPolicy do

  subject { described_class.new(admin_user, admin_user_2) }
  
  let(:admin_user) { create(:admin_user) }
  let(:admin_user_2) { create(:admin_user) }

  context 'when user has role admin' do

    before do
      admin_user.has_role!(:admin)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
    it { is_expected.to permit_action(:index) }
    it { is_expected.to permit_action(:create_admin) }
    it { is_expected.to permit_action(:add_role_admin) }
    it { is_expected.to forbid_action(:update_password) }
    it { is_expected.to forbid_action(:edit_password) }
    it { is_expected.to permit_action(:enable) }
    it { is_expected.to permit_action(:disable) }
    it { is_expected.to permit_action(:new_admin) }

    context 'when it is the same admin_user' do

      subject { described_class.new(admin_user, admin_user) }

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_action(:index) }
      it { is_expected.to permit_action(:create_admin) }
      it { is_expected.to permit_action(:add_role_admin) }
      it { is_expected.to permit_action(:update_password) }
      it { is_expected.to permit_action(:edit_password) }
      it { is_expected.to forbid_action(:enable) }
      it { is_expected.to forbid_action(:disable) }
      it { is_expected.to permit_action(:new_admin) }

    end

  end
end
