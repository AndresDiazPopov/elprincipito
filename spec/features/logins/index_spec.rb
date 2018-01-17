require "rails_helper"

describe "the logins panel", type: :feature do

  login_admin_user

  context 'when logins exist' do

    let!(:logins) { create_list(:login, 5) }

    check_sortable_table_headers(
      path: '/admin/logins', 
      table_name: 'logins', 
      table_localized_title: _('Logins'))

  end

end