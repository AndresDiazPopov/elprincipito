class Users::LoginWithIdentity

  def self.call(provider_name:, provider_uid:, provider_token:, login_params:, device_params:)
    identity = Identity.find_by(:provider => provider_name, :uid => provider_uid)

    if identity.nil?

      # No se registra como un login fallido, porque es el flujo normal
      # para el primer uso de la app
      # login = Logins::Create.call(login_params: login_params)
      # Logins::Deny.call(login: login, denied_reason: 'No existe ese identity')
      raise Exceptions::NotFoundError, Identity unless identity
    else
      identity.update_attributes!(token: provider_token)
      login_params[:user] = identity.user
      login = Logins::Create.call(login_params: login_params, device_params: device_params)

      if AppVersions::IsExpired.call(app_version: login.app_version)
        Logins::Deny.call(login: login, denied_reason: login.app_version.expired_message)
        raise Exceptions::AppVersionExpiredError, login.app_version.expired_message
      end

      Logins::Authorize.call(login: login)

      [identity.user, login]
    end
  end

end