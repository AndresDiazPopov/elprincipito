module JsonSchemas

  require 'airborne/request_expectations'

  USER = {
    id: :int,
    image_url: :string_or_null,
    image_thumb_url: :string_or_null
  }

  USER_PRIVATE = USER.merge({
    email: :string_or_null,
    api_key: :string,
    identities: :array_of_objects,
    roles: :array_of_objects
  })

  USER_AFTER_LOGIN = USER_PRIVATE.merge({
    login_code: :string
  })

  ROLE = {
    role: :string
  }

  IDENTITY = {
    id: :int, 
    provider: :string,
    uid: :string,
    token: :string,
    token_secret: :string_or_null
  }

end