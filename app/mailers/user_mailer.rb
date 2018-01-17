class UserMailer < ActionMailer::Base

  layout 'mailer/user_template'

  include MailHelper

  def password_reset(user_id:)
    @user = User.find(user_id)
    @subject = _("Reset password")
    mail(to: @user.email, subject: @subject)
  end

end
