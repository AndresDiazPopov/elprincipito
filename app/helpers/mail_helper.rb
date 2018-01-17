module MailHelper
  def prefix_subject(subject)
    '[' + Figaro.env.app_name + '] ' + subject
  end
end
