class Users::LinkProvider

  def self.call(user:, provider_name:, provider_uid:, provider_token:, provider_token_secret: nil)
    raise Exceptions::DuplicatedEntityError, Identity if Identity.exists?(:user => user, :provider => provider_name)
    raise Exceptions::AlreadyLinkedToAnotherUserError if Identity.exists?(:provider => provider_name, :uid => provider_uid)
    identity = Identity.find_or_initialize_by(:provider => provider_name, :uid => provider_uid)
    identity.update_attributes!(:user => user, :token => provider_token, :token_secret => provider_token_secret)
    user
  end

end