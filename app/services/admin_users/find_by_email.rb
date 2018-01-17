class AdminUsers::FindByEmail

  def self.call(email:)
    begin
      AdminUser.find_by(email: email)
    rescue ActiveRecord::RecordNotFound
      raise Exceptions::NotFoundError, AdminUser
    end
  end

end