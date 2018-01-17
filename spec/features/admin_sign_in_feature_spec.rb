require "rails_helper"

describe "the signin process for admins", :type => :feature do

  context 'when an admin exists' do
    
    before(:each) do
      @admin_user = create(:admin_user, :admin, email: 'admin@example.com', password: 'password')
    end

    it "signs an admin in" do
      visit '/admin/login'
      within("#new_admin_user") do
        fill_in 'admin_user[email]', with: 'admin@example.com'
        fill_in 'admin_user[password]', with: 'password'
      end
      click_button I18n.t('admin_users.sessions.new.sign_in')
      # expect(page).to have_content 'Dashboard'
    end

    it "shows error with bad credentials" do
      visit '/admin/login'
      within("#new_admin_user") do
        fill_in 'admin_user[email]', with: Faker::Internet.unique.email
        fill_in 'admin_user[password]', with: 'password'
      end
      click_button I18n.t('admin_users.sessions.new.sign_in')
      # expect(page).to have_content I18n.t('admin_users.sessions.new.sign_in')
    end

  end

end