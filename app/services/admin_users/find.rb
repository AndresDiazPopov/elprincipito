class AdminUsers::Find

  def self.call(id: nil)
    begin
      AdminUser.find(id)
    rescue ActiveRecord::RecordNotFound
      raise Exceptions::NotFoundError, AdminUser
    end
  end

end