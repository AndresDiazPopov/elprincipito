class Users::Delete

  def self.call(user:)
    user.destroy
  end

end