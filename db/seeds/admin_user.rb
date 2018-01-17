admin_user = AdminUser.find_or_create_by(email: 'admin@example.com')
admin_user.update_attributes(full_name: 'Administrador general', password: 'password', password_confirmation: 'password')
admin_user.has_role! :admin