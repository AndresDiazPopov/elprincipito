require "rails_helper"

describe "the api_requests panel", type: :feature do

  login_admin_user

  context 'when api_requests exist' do

    let!(:api_requests) { create_list(:api_request, 5) }

    check_sortable_table_headers(
      path: '/admin/api_requests', 
      table_name: 'api_requests', 
      table_localized_title: _('Peticiones al API'))

  end

end