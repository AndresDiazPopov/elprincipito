class AdminUserMailer < ActionMailer::Base

  layout 'mailer/admin_user_template'

  include MailHelper

  def welcome(admin_user_id:, password:)
    @admin_user = AdminUser.find(admin_user_id)
    @password = password
    @app_name = Figaro.env.app_name
    subject = prefix_subject(_('Bienvenido a') + ' ' + @app_name)
    mail(to: @admin_user.email, subject: subject)
  end

  def role_added(admin_user_id:, role_name:, authorizable_name: nil)
    @admin_user = AdminUser.find(admin_user_id)
    @role_name = AdminRole.name_for(role_name)
    @authorizable_name = authorizable_name
    @app_name = Figaro.env.app_name
    subject = prefix_subject(_('Has sido dado de alta como') + ' ' + @role_name)
    mail(to: @admin_user.email, subject: subject)
  end

  def role_deleted(admin_user_id:, role_name:, authorizable_name: nil)
    @admin_user = AdminUser.find(admin_user_id)
    @role_name = AdminRole.name_for(role_name)
    @authorizable_name = authorizable_name
    @app_name = Figaro.env.app_name
    subject = prefix_subject(_('Has sido dado de baja como') + ' ' + @role_name)
    mail(to: @admin_user.email, subject: subject)
  end

  private

    def send_to_all_admin_users(subject)
      AdminUser.with_role(:admin).each do |admin_user|
        mail(to: admin_user.email, subject: subject)
      end
    end

end
