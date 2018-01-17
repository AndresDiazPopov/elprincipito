class AdminUsers::Disable

  def self.call(admin_user:)
    admin_user.disable! if admin_user.may_disable?
  end

end