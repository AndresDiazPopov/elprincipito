require 'rails_helper'

describe "admin/users/_actions.html.erb", type: :view do

  context 'when an enabled user exist' do
    
    let(:user) { create(:user, state: :enabled) }

    it "displays the edit and disable actions" do
      render partial: "admin/users/actions.html.erb", locals: { user: user }

      expect(rendered).to match _('Deshabilitar')
    
    end

  end

  context 'when a disabled user exist' do
    
    let(:user) { create(:user, state: :disabled) }

    it "displays the edit and enable actions" do
      render partial: "admin/users/actions.html.erb", locals: { user: user }

      expect(rendered).to match _('Habilitar')
    
    end

  end

end