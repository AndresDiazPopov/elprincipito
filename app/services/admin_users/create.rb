class AdminUsers::Create

  def self.call(admin_user_params:, role:, authorizable_type: nil, authorizable_id: nil)
    admin_user = AdminUser.new(admin_user_params)

    password = self.generate_random_password
    admin_user.password = password

    AdminUser.transaction do

      begin
        admin_user.save!
      rescue ActiveRecord::RecordInvalid
        raise ActiveRecord::Rollback
      end

      begin
        AdminRoles::Create.call(
          admin_user: admin_user,
          role: role,
          authorizable_type: authorizable_type,
          authorizable_id: authorizable_id,
          skip_confirmation: true)
        # En caso de excepción, quiero guardar los datos temporales en el admin_user
      rescue Exceptions::DuplicatedRoleError
        # No debería pasar nunca, el administrador todavía no existe
        admin_user.errors.add(:base, _('Ese administrador ya tiene ese rol'))
        raise ActiveRecord::Rollback
      end

      AdminUserMailer.delay.welcome(
        admin_user_id: admin_user.id,
        password: password)
    end

    admin_user
  end

  private

    def self.generate_random_password
      Devise.friendly_token.first(8)
    end

end