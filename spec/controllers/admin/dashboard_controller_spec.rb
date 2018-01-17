require 'rails_helper'

describe Admin::DashboardController, type: :controller do

  context 'when logged in as admin' do

    login_admin_user

    it "should have a current_user" do
      expect(subject.current_admin_user).to_not eq(nil)
    end

    describe 'GET #dashboard' do

      it "gets the dashboard" do
        get :dashboard
        expect(response).to be_success
      end

    end

  end

end
