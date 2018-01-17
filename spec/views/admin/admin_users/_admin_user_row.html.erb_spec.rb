require 'rails_helper'

describe "admin/admin_users/_admin_user_row.html.erb", type: :view do

  create_admin_user_and_stub_policies

  AdminRole.roles.each do |role|

    role_name = role[0]

    context 'when an admin_user exist' do
      
      before(:each) do
        @admin_user = create(:admin_user)
        @admin_user.has_role!(role_name)
      end

      it "displays the admin_user information" do
        render partial: "admin/admin_users/admin_user_row.html.erb", :locals => {admin_user: @admin_user}

        expect(rendered).to match @admin_user.id.to_s
        expect(rendered).to match @admin_user.email
        # Muestra el primero de los roles
        expect(rendered).to match @admin_user.state_string
        expect(rendered).to match @admin_user.created_at.to_s
        expect(rendered).to match @admin_user.updated_at.to_s
      
      end

    end

  end

end