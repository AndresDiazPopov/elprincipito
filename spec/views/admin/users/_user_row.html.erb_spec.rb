require 'rails_helper'

describe "admin/users/_user_row.html.erb", type: :view do

  context 'when a user exist' do
    
    before(:each) do
      @user = create(:user)
    end

    it "displays the user information" do
      render partial: "admin/users/user_row.html.erb", :locals => {user: @user}

      expect(rendered).to match @user.id.to_s
      expect(rendered).to match @user.image.url(:thumb)
      expect(rendered).to match @user.email
      expect(rendered).to match @user.created_at.to_s
      expect(rendered).to match @user.updated_at.to_s
    
    end

  end

end