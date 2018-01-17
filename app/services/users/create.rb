class Users::Create

  def self.call(email: nil, 
    password: nil, 
    image: nil, 
    image_url: nil, 
    provider_name: nil, 
    provider_uid: nil, 
    provider_token: nil, 
    provider_token_secret: nil, 
    login_params:,
    device_params:)
    image = open(URI.decode(image_url)) if image_url
    
    # Si ese email ya existe
    raise Exceptions::DuplicatedEntityError, User if User.exists?(email: email) && !email.nil?
    # Si ese identity ya existe
    raise Exceptions::DuplicatedEntityError, Identity if Identity.exists?(provider: provider_name, uid: provider_uid) && !provider_name.nil? && !provider_uid.nil?
    
    user = User.new(email: email, password: password, image: image)
    if provider_name
      identity = Identity.find_or_initialize_by(:provider => provider_name, :uid => provider_uid)
      identity.token = provider_token
      identity.token_secret = provider_token_secret
      user.identities << identity
    end
    user.skip_confirmation!
    user.has_role! :user

    login_params[:user] = user
    login = Logins::Create.call(login_params: login_params, device_params: device_params)

    if user.save
      
      if AppVersions::IsExpired.call(app_version: login.app_version)
        Logins::Deny.call(login: login, denied_reason: login.app_version.expired_message)
        raise Exceptions::AppVersionExpiredError, login.app_version.expired_message
      else
        Logins::Authorize.call(login: login)
      end
    else
      Logins::Deny.call(login: login, denied_reason: 'Error de validación creando al usuario: ' + user.errors.full_messages.to_s)
    end

    [user, login]
  end

end