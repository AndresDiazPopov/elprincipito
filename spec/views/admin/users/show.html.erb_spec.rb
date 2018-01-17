require 'rails_helper'

describe "admin/users/show.html.erb", type: :view do

  create_admin_user_and_stub_policies
  
  context 'when users exist' do
    
    before(:each) do
      @user = create(:user)
    end

    it "shows the user information" do
      assign(:user, @user)

      render

      expect(rendered).to match @user.id.to_s
      expect(rendered).to match @user.image.url(:thumb)
      expect(rendered).to match @user.email
      expect(rendered).to match @user.created_at.to_s
      expect(rendered).to match @user.updated_at.to_s
    end

  end

end