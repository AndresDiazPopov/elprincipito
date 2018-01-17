require 'rails_helper'

describe "admin/users/index.html.erb", type: :view do

  context "when #{Kaminari.config.default_per_page + 1} users exist" do
    
    before(:each) do
      @users = create_list(:user, Kaminari.config.default_per_page + 1)
    end

    it "displays all the users information for the first #{Kaminari.config.default_per_page}" do
      assign(:users, Kaminari.paginate_array(@users).page(1))

      render

      @users[0..Kaminari.config.default_per_page - 1].each do |user|
        expect(rendered).to match user.id.to_s
        expect(rendered).to match user.image.url(:thumb)
        expect(rendered).to match user.email
        expect(rendered).to match user.created_at.to_s
        expect(rendered).to match user.updated_at.to_s
      end
      expect(rendered).to_not match @users[Kaminari.config.default_per_page].email
    end

    it "displays page_entries_info and pagination sections" do
      assign(:users, Kaminari.paginate_array(@users).page(1))

      render

      expect(rendered).to match 'page_entries_info'
      expect(rendered).to match 'paginator'

    end

  end

  context 'when no user exists' do

    it "shows no users message" do
      users = []
      assign(:users, Kaminari.paginate_array(users).page(1))

      render

      expect(rendered).to match '.empty-p'
    end

  end

end