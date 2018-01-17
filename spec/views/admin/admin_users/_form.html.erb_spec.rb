require 'rails_helper'

describe "admin/admin_users/_form.html.erb", type: :view do

  create_admin_user_and_stub_policies

  context 'when an admin_user exist' do
    
    before(:each) do
      @admin_user = create(:admin_user)
    end

    it "shows the save button" do
      render partial: "admin/admin_users/form.html.erb", locals: { admin_user: @admin_user }

      expect(rendered).to match 'name="commit"'
    
    end

  end

end