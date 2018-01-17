class Logins::Authorize

  def self.call(login:)
    login.authorize! if login.may_authorize?
  end

end