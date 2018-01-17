class Users::Enable

  def self.call(user:)
    user.enable! if user.may_enable?
  end

end