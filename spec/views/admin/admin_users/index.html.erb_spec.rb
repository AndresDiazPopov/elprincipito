require 'rails_helper'

describe "admin/admin_users/index.html.erb", type: :view do

  create_admin_user_and_stub_policies

  AdminRole.roles.each do |role|

    role_name = role[0]

    context "when #{Kaminari.config.default_per_page + 1} admin_users exist" do
      
      before(:each) do
        @admin_users = create_list(:admin_user, Kaminari.config.default_per_page + 1)
        @admin_users.each do |admin_user|
          assigned_role = AdminRole.roles.keys.sample
          admin_user.has_role!(assigned_role)
        end
      end

      it "displays page_entries_info and pagination sections" do
        assign(:admin_users, Kaminari.paginate_array(AdminUser.with_role(role_name)).page(1))
        assign(:role, role_name)

        render

        expect(rendered).to match 'page_entries_info'
        expect(rendered).to match 'paginator'

      end

    end

    context 'when no admin_user exists' do

      it "shows no admin_users message" do
        admin_users = []
        assign(:admin_users, Kaminari.paginate_array(admin_users).page(1))
        assign(:role, role_name)

        render

        expect(rendered).to match '.empty-p'
      end

    end

  end

end