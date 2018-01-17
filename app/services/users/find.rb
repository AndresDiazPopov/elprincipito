class Users::Find

  def self.call(id:)
    begin
      User.find(id)
    rescue ActiveRecord::RecordNotFound
      raise Exceptions::NotFoundError, User
    end
  end

end