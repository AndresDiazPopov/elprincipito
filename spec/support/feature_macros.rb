module FeatureMacros
  def login_admin_user
    before do
      admin_user = FactoryGirl.create(:admin_user, created_at: Time.now)
      admin_user.has_role! :admin
      login_as(admin_user, scope: :admin_user)
    end
  end

  def check_sortable_table_headers(path:, table_name:, table_localized_title:)
    it "Orders the #{table_name} by all sorts column" do
      visit path

      sortable_headers = page.find("thead tr").all("th a")
      sortable_headers.each do |sortable_header|
        click_link(sortable_header.native.text)
        expect(page).to have_content table_localized_title
      end
      
    end
  end

end