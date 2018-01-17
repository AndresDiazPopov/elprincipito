require 'rails_helper'

describe Admin::AdminUsersController, type: :controller do

  context 'when logged in as admin' do

    login_admin_user

    it "should have a current_user" do
      expect(subject.current_admin_user).to_not eq(nil)
    end

    describe 'GET #show' do

      it "raises Exceptions::NotFoundError when id not found" do
        get :show, id: Faker::Number.number(2)
        expect(response).to redirect_to(admin_dashboard_path)
      end

    end

    describe 'GET #edit' do

      it "raises Exceptions::NotFoundError when id not found" do
        get :edit, id: Faker::Number.number(2)
        expect(response).to redirect_to(admin_dashboard_path)
      end

    end

    describe 'GET #edit_password' do

      it "raises Exceptions::NotFoundError when id not found" do
        get :edit_password, id: Faker::Number.number(2)
        expect(response).to redirect_to(admin_dashboard_path)
      end

    end

    describe 'GET #index' do

      it "gets the index" do
        get :index
        expect(response).to be_success
        expect(response).to render_template(:index)
      end

      it "assigns admin_users to the only admin_users" do
        create_list(:admin_user, Kaminari.config.default_per_page + 1)
        admin_users = AdminUser.all
        get :index

        expect(assigns(:admin_users).count).to eq(AdminUser.limit(Kaminari.config.default_per_page).count)
      end

    end

    describe 'GET #new' do

      it "gets the admin initialized, ready to be created" do
        get :new, 
          role: :admin
        expect(response).to be_success
        expect(response).to render_template(:new_admin)
        expect(assigns(:admin_user)).to_not be_nil
      end

    end

    describe 'POST #create' do

      it "creates a valid admin" do
        post :create, admin_user: {
          email: Faker::Internet.email,
          full_name: Faker::Name.name },
          role: :admin
        expect(response).to redirect_to(admin_admin_user_path(assigns(:admin_user)))
      end

    end

    describe 'PUT #add_role' do

      context 'when an admin_user exists' do

        let(:admin_user) { create(:admin_user) }

        it "adds the admin role to it" do
          put :add_role, 
            id: admin_user.id,
            role: :admin
          expect(admin_user.has_role?(:admin)).to be_truthy
        end

      end

    end

    context 'when an admin exists' do

      before(:each) do
        @admin_user = create(:admin_user)
      end

      describe 'GET #show' do

        it "gets the admin_user" do
          get :show, id: @admin_user.id
          expect(response).to be_success
          expect(response).to render_template(:show)
          expect(assigns(:admin_user)).to eq(@admin_user)
        end

      end

      describe 'GET #edit' do

        it "gets the admin_user" do
          get :edit, id: @admin_user.id
          expect(response).to be_success
          expect(response).to render_template(:edit)
          expect(assigns(:admin_user)).to eq(@admin_user)
        end

      end

      describe 'GET #edit_password' do

        it "gets the admin_user" do
          get :edit_password, id: @current_admin_user.id
          expect(response).to be_success
          expect(response).to render_template(:edit_password)
          expect(assigns(:admin_user)).to eq(@current_admin_user)
        end

      end

      describe 'POST #update' do

        it "updates the email" do
          expect {
            post :update, id: @admin_user.id, admin_user: { email: Faker::Internet.unique.email }
          }.to change{@admin_user.reload.email}
        end

        it "redirects to #show" do
          post :update, id: @admin_user.id, admin_user: { email: Faker::Internet.unique.email }
          expect(response).to redirect_to(admin_admin_user_path(assigns(:admin_user)))
        end

      end

    end

    context 'an enabled admin_user exists' do

      before(:each) do
        @admin_user = create(:admin_user, state: 'enabled')
      end

      describe 'PUT #enable' do

        it "does nothing with the admin_user" do
          put :enable, id: @admin_user.id, format: :js
          expect(@admin_user).to have_state(:enabled)
        end

      end

      describe 'PUT #disable' do

        it "disables the admin_user" do
          put :disable, id: @admin_user.id, format: :js
          expect(@admin_user.reload).to have_state(:disabled)
        end

      end

    end

    context 'a disabled admin_user exists' do

      before(:each) do
        @admin_user = create(:admin_user, state: 'disabled')
      end

      describe 'PUT #enable' do

        it "enables the admin_user" do
          put :enable, id: @admin_user.id, format: :js
          expect(@admin_user.reload).to have_state(:enabled)
          expect(assigns(:admin_user)).to_not be_nil
        end

      end

      describe 'PUT #disable' do

        it "does nothing with the admin_user" do
          put :disable, id: @admin_user.id, format: :js
          expect(@admin_user.reload).to have_state(:disabled)
          expect(assigns(:admin_user)).to_not be_nil
        end

      end

    end

  end

end
