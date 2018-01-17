class Users::LoginWithApiKey

  def self.call(api_key:, login_params:, device_params:)
    user ||= User.where(:api_key => api_key).first

    login_params[:user] = user
    login = Logins::Create.call(login_params: login_params, device_params: device_params)

    if AppVersions::IsExpired.call(app_version: login.app_version)
      Logins::Deny.call(login: login, denied_reason: login.app_version.expired_message)
      raise Exceptions::AppVersionExpiredError, login.app_version.expired_message
    end
      
    if user.nil?
      Logins::Deny.call(login: login, denied_reason: 'No existe la clave del API: ' + api_key)
      raise Exceptions::NotFoundError, User
    end

    Logins::Authorize.call(login: login)

    [user, login]
  end

end