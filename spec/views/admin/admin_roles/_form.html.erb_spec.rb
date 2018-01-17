require 'rails_helper'

describe "admin/admin_roles/_form.html.erb", type: :view do

  context 'when an admin_user exist' do
    
    before(:each) do
      @admin_user = create(:admin_user)
      @admin_role = AdminRole.new
    end

    it "shows the role field" do
      render partial: "admin/admin_roles/form.html.erb", locals: { admin_user_id: @admin_user.id, admin_user: @admin_user, admin_role: @admin_role }

      expect(rendered).to match 'admin_role_name'
    
    end

    it "shows all the roles in the select" do
      render partial: "admin/admin_roles/form.html.erb", locals: { admin_user_id: @admin_user.id, admin_user: @admin_user, admin_role: @admin_role }

      AdminRole.roles.each do |role|
        expect(rendered).to match AdminRole.name_for(role[0])
      end
    
    end

    it "shows the save button" do
      render partial: "admin/admin_roles/form.html.erb", locals: { admin_user_id: @admin_user.id, admin_user: @admin_user, admin_role: @admin_role }

      expect(rendered).to match 'name="commit"'
    
    end

  end

end