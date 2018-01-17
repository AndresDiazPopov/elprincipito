class Users::Update

  def self.call(user:, old_password: nil, new_password: nil, image: nil, image_url: nil)
    image = open(URI.decode(image_url)) if image_url
    attributes = {}
            
    if old_password
      raise Exceptions::UnauthorizedError unless user.valid_password?(old_password)
      attributes[:password] = new_password
      attributes[:password_confirmation] = new_password
    end

    attributes[:image] = image if image

    user.update!(attributes)

    user
  end

end