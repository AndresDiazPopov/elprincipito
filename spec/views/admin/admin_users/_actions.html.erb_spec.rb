require 'rails_helper'

describe "admin/admin_users/_actions.html.erb", type: :view do

  create_admin_user_and_stub_policies

  context 'when an enabled admin_user exist' do
    
    before(:each) do
      @admin_user = create(:admin_user, state: :enabled)
    end

    it "displays the edit and disable actions" do
      render partial: "admin/admin_users/actions.html.erb", locals: { admin_user: @admin_user }

      expect(rendered).to match _('Editar')
      expect(rendered).to match _('Deshabilitar')
    
    end

  end

  context 'when a disabled admin_user exist' do
    
    before(:each) do
      @admin_user = create(:admin_user, state: :disabled)
    end

    it "displays the edit and enable actions" do
      render partial: "admin/admin_users/actions.html.erb", locals: { admin_user: @admin_user }

      expect(rendered).to match _('Editar')
      expect(rendered).to match _('Habilitar')
    
    end

  end

end