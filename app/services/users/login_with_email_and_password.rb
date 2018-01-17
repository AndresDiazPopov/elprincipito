class Users::LoginWithEmailAndPassword

  def self.call(email:, password:, login_params:, device_params:)
    user ||= User.where(email: email).first

    login_params[:user] = user
    login = Logins::Create.call(login_params: login_params, device_params: device_params)

    if AppVersions::IsExpired.call(app_version: login.app_version)
      Logins::Deny.call(login: login, denied_reason: login.app_version.expired_message)
      raise Exceptions::AppVersionExpiredError, login.app_version.expired_message
    end

    if user.nil?
      Logins::Deny.call(login: login, denied_reason: 'No existe el usuario con ese email/password: ' + email)
      raise Exceptions::NotFoundError, User
    end

    if !user.valid_password?(password)
      Logins::Deny.call(login: login, denied_reason: 'No existe el usuario con ese email/password: ' + email)
      raise Exceptions::InvalidPasswordError 
    end

    Logins::Authorize.call(login: login)

    [user, login]
  end

end