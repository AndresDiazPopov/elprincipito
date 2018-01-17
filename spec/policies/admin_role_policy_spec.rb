require 'rails_helper'

RSpec.describe AdminRolePolicy do

  subject { described_class.new(admin_user, admin_role) }
  
  let(:admin_user) { create(:admin_user) }
  let(:admin_role) { create(:admin_role) }

  context 'when user has role admin' do

    before do
      admin_user.has_role!(:admin)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
    it { is_expected.to permit_action(:index) }

  end

end
