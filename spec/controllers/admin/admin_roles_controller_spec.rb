require 'rails_helper'

describe Admin::AdminRolesController, type: :controller do

  context 'when an admin_user exist' do

    login_admin_user

    before(:each) do
      @admin_user = create(:admin_user)
    end

    it "should have a current_user" do
      expect(subject.current_admin_user).to_not eq(nil)
    end

    describe 'GET #new' do

      it "gets the admin_role initialized, ready to be created" do
        get :new, admin_user_id: @admin_user.id
        expect(response).to be_success
        expect(response).to render_template(:new)
        expect(assigns(:admin_role)).to_not be_nil
      end

      it "sets the admin_user to the specified admin_user" do
        get :new, admin_user_id: @admin_user.id
        expect(response).to be_success
        expect(response).to render_template(:new)
        expect(assigns(:admin_user)).to eq(@admin_user)
      end

    end

    describe 'POST #create' do

      it "creates a valid :admin role" do
        post :create, admin_user_id: @admin_user.id, admin_role: {
          name: :admin}
        expect(response).to redirect_to(admin_admin_user_path(assigns(:admin_user)))
        expect(@admin_user.reload.has_role?(:admin)).to be_truthy
      end

      it "creates a valid :company_admin role" do
        post :create, admin_user_id: @admin_user.id, admin_role: {
          name: :company_admin}
        expect(response).to redirect_to(admin_admin_user_path(assigns(:admin_user)))
        expect(@admin_user.reload.has_role?(:company_admin)).to be_truthy
      end

    end

    describe 'DELETE #destroy' do

      AdminRole.roles.each do |role|

        role_name = role[0]

        context "when admin_user has #{role_name} role" do

          before(:each) do
            @admin_user.has_role!(role_name)
            @role = @admin_user.roles.first
          end

          it "removes the role from the admin_user" do
            delete :destroy, 
              format: :js, admin_user_id: @admin_user.id, id: @role.id
            expect(response).to be_success
            expect(response).to render_template(:destroy)
          end

        end

      end

    end

  end

end
