class Users::Disable

  def self.call(user:)
    user.disable! if user.may_disable?
  end

end