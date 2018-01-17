class Users::RequestPasswordResetInstructions

  def self.call(email:)
    user = User.find_by_email(email)
    raise Exceptions::NotFoundError, User unless user

    User.transaction do
      user.reset_password_token = [*0..9999].sample.to_s.rjust(4, "0")
      user.reset_password_sent_at = Time.now.utc
      user.save(validate: false)
      user.save!
      UserMailer.delay.password_reset(user_id: user.id)
    end
  end

end