require "rails_helper"

describe "the users panel", type: :feature do

  login_admin_user

  context 'when users exist' do

    let!(:users) { create_list(:user, 5) }

    check_sortable_table_headers(
      path: '/admin/users', 
      table_name: 'users', 
      table_localized_title: _('Usuarios'))

  end

end