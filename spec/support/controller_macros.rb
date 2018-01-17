module ControllerMacros
  def login_admin_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @current_admin_user_password = Faker::Internet.password
      @current_admin_user = FactoryGirl.create(:admin_user, password: @current_admin_user_password)
      @current_admin_user.has_role! :admin
      sign_in @current_admin_user # Using factory girl as an example
    end
  end
end