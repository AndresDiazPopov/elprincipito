require 'rails_helper'

describe Admin::UsersController, type: :controller do

  context 'when logged in as admin' do

    login_admin_user

    it "should have a current_admin_user" do
      expect(subject.current_admin_user).to_not eq(nil)
    end

    describe 'GET #index' do

      it "gets the index" do
        get :index
        expect(response).to be_success
        expect(response).to render_template(:index)
      end

      it "assigns :users to the first #{Kaminari.config.default_per_page} users" do
        users = create_list(:user, Kaminari.config.default_per_page + 1)
        get :index
        expect(assigns(:users).count).to eq(User.limit(Kaminari.config.default_per_page).count)
      end

    end

    context 'an enabled user exists' do

      let(:user) { create(:user, state: 'enabled') }

      describe 'PUT #enable' do

        it "does nothing with the user" do
          put :enable, id: user.id, format: :js
          expect(user).to have_state(:enabled)
        end

      end

      describe 'PUT #disable' do

        it "disables the user" do
          put :disable, id: user.id, format: :js
          expect(user.reload).to have_state(:disabled)
        end

      end

    end

    context 'a disabled user exists' do

      let(:user) { create(:user, state: 'disabled') }

      describe 'PUT #enable' do

        it "enables the user" do
          put :enable, id: user.id, format: :js
          expect(user.reload).to have_state(:enabled)
          expect(assigns(:user)).to_not be_nil
        end

      end

      describe 'PUT #disable' do

        it "does nothing with the user" do
          put :disable, id: user.id, format: :js
          expect(user.reload).to have_state(:disabled)
          expect(assigns(:user)).to_not be_nil
        end

      end

    end

  end

end
