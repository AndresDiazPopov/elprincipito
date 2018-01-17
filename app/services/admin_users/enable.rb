class AdminUsers::Enable

  def self.call(admin_user:)
    admin_user.enable! if admin_user.may_enable?
  end

end