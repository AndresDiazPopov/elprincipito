class AdminUsers::UpdatePassword

  def self.call(admin_user:, admin_user_params:)
    if !admin_user.valid_password?(admin_user_params[:current_password])
      admin_user.errors.add(:current_password, _('no es válida'))
    elsif admin_user_params[:password] != admin_user_params[:password_confirmation]
      admin_user.errors.add(:base, _('La nueva contraseña y la confirmación no coinciden'))
    else
      params = admin_user_params.dup
      params.delete(:current_password)
      params.delete(:password_confirmation)
      admin_user.update_attributes(params)
    end
    admin_user
  end

end