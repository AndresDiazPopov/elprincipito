class Logins::Deny

  def self.call(login:, denied_reason:)
    if login.may_deny?
      login.update_attributes(denied_reason: denied_reason)
      login.deny!
    end
  end

end