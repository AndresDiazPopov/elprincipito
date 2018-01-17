require 'rails_helper'

describe "admin/admin_roles/_admin_role_row.html.erb", type: :view do

  create_admin_user_and_stub_policies

  AdminRole.roles.each do |role|

    role_name = role[0]

    context "when an admin_user with role #{role_name} exist" do
      
      before(:each) do
        @admin_user = create(:admin_user)
        @admin_user.has_role!(role_name)
        @role = @admin_user.roles.first
      end

      it "displays the role name and authorizable name" do
        render partial: "admin/admin_roles/admin_role_row.html.erb", :locals => {admin_user: @admin_user, role: @role}

        expect(rendered).to match AdminRole.name_for(@role.name)
      
      end

      it "displays the delete button" do
        render partial: "admin/admin_roles/admin_role_row.html.erb", :locals => {admin_user: @admin_user, role: @role}

        expect(rendered).to match _('Dar de baja')
      
      end

    end

  end

end