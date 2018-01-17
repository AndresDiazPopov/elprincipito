class AdminUsers::Search

  def self.call(text: nil, state: nil, role: nil)

    # Primero filtro por state
    admin_users = state ? AdminUser.where(state: AdminUser.states[state]) : AdminUser.all

    # Search by text
    admin_users = admin_users.where('email LIKE ? OR full_name LIKE ?', "%#{text}%", "%#{text}%") if text

    # Search by roles
    admin_users = admin_users.joins(:roles).where('admin_roles.name =?', role) if role

    admin_users
  end

end