class AdminRoles::Delete

  def self.call(admin_user:, role:, authorizable_id: nil)

    AdminRole.transaction do
      if authorizable_id

        authorizable = authorizable_type.find(authorizable_id)

        admin_user.has_no_role!(role, authorizable)

        AdminUserMailer.delay.role_deleted(
          admin_user_id: admin_user.id,
          role_name: role, 
          authorizable_name: authorizable.try(:name))

      else
        admin_user.has_no_role!(role)
        
        AdminUserMailer.delay.role_deleted(
          admin_user_id: admin_user.id,
          role_name: role)

      end
    end
  end

end