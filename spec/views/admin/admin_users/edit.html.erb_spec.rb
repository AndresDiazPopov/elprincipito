require 'rails_helper'

describe "admin/admin_users/edit.html.erb", type: :view do

  create_admin_user_and_stub_policies

  context 'when admin_user exist' do

    before(:each) do
      @admin_user = create(:admin_user)
    end

    it "displays the save button" do
      assign(:admin_user, @admin_user)

      render

      expect(rendered).to match 'name="commit"'
      
    end

  end

end