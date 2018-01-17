class AdminRoleAdminUser < ActiveRecord::Base

  self.table_name = 'admin_roles_admin_users'

  belongs_to :admin_user
  belongs_to :admin_role
  
end
