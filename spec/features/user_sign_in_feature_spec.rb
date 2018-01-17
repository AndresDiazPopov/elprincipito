require "rails_helper"

describe "the signin process for users", :type => :feature do

  context 'when an user exists' do
    
    before(:each) do
      @user = create(:user, email: 'user@example.com', password: 'password')
    end

    it "signs an user in" do
      visit '/public/login'
      within("#new_user") do
        fill_in 'user[email]', with: 'user@example.com'
        fill_in 'user[password]', with: 'password'
      end
      click_button I18n.t('users.sessions.new.sign_in')
      # expect(page).to have_content 'Dashboard'
    end

    it "shows error with bad credentials" do
      visit '/public/login'
      within("#new_user") do
        fill_in 'user[email]', with: Faker::Internet.unique.email
        fill_in 'user[password]', with: 'password'
      end
      click_button I18n.t('users.sessions.new.sign_in')
      # expect(page).to have_content I18n.t('users.sessions.new.sign_in')
    end

  end

end