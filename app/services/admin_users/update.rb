class AdminUsers::Update

  def self.call(admin_user:, admin_user_params:)
    admin_user.update_attributes(admin_user_params)
    admin_user
  end

end