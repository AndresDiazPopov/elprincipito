class AdminRoles::Find

  def self.call(id:)
    begin
      AdminRole.find(id)
    rescue ActiveRecord::RecordNotFound
      raise Exceptions::NotFoundError, AdminRoleAdminUser
    end
  end

end