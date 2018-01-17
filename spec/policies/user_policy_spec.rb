require 'rails_helper'

RSpec.describe UserPolicy do

  subject { described_class.new(admin_user, user) }
  
  let(:admin_user) { create(:admin_user) }
  let(:user) { create(:user) }

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
