class Users::ResetPassword

  def self.call(email:, code:, password:)
    user = User.find_by(:email => email, :reset_password_token => code)
    raise Exceptions::NotFoundError, User unless user

    raise Exceptions::ResetPasswordCodeExpiredError unless user.reset_password_period_valid?

    raise Exceptions::UnauthorizedError unless user.reset_password(password, password)
    user.reset_password_token = nil
    user.reset_password_sent_at = nil
    user.save
  end

end