class Users::UnlinkProvider

  def self.call(user:, provider_name:)
    if identity = Identity.find_by(:user => user, :provider => provider_name)
      raise Exceptions::OnlyLinkedToThisProviderError if user.identities.count == 1 && user.email.nil?
      identity.destroy 
      user
    else
      raise Exceptions::NotFoundError, Identity
    end
  end

end