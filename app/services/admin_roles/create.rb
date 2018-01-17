class AdminRoles::Create

  def self.call(admin_user:, role:, authorizable_type: nil, authorizable_id: nil, skip_confirmation: nil)

    if authorizable_type && authorizable_id
      AdminRole.transaction do

        authorizable = authorizable_type.find(authorizable_id)

        admin_user.has_role!(role, authorizable)
        
        AdminUserMailer.delay.role_added(
          admin_user_id: admin_user.id,
          role_name: role, 
          authorizable_name: authorizable.try(:name)) unless skip_confirmation

      end
    else
      admin_user.has_role!(role)

      AdminUserMailer.delay.role_added(
        admin_user_id: admin_user.id,
        role_name: role) unless skip_confirmation
    end
  end

end