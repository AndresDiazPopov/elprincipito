require 'rails_helper'

describe "admin/admin_users/show.html.erb", type: :view do

  create_admin_user_and_stub_policies

  context 'when an admin_user exists' do
    
    before(:each) do
      @admin_user = create(:admin_user)
    end

    it "shows the admin_user information" do
      assign(:admin_user, @admin_user)

      render

      expect(rendered).to match @admin_user.id.to_s
      expect(rendered).to match @admin_user.email
      expect(rendered).to match @admin_user.state_string
      expect(rendered).to match @admin_user.created_at.to_s
      expect(rendered).to match @admin_user.updated_at.to_s
    end

  end

end