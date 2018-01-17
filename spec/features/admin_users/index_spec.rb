require "rails_helper"

describe "the admin_users panel", type: :feature do

  login_admin_user

  context 'when admin_users exist' do

    let!(:admin_users) { create_list(:admin_user, 5) }

    check_sortable_table_headers(
      path: '/admin/admin_users', 
      table_name: 'admin_users', 
      table_localized_title: _('Usuarios'))

  end

end