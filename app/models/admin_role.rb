class AdminRole < ActiveRecord::Base

  acts_as_authorization_role :subject_class_name => 'AdminUser'

  has_many :admin_role_admin_users, dependent: :destroy
  has_many :admin_users, :class_name => "AdminRole", :through => :admin_role_admin_users, :foreign_key => "admin_user_id", :source => :admin_role, dependent: :destroy

  enum roles: [ :admin ]

    def self.name_for(role_name)
    case role_name.to_sym
    when :admin
      _('Administrador')
    end
  end

  def self.plural_name_for(role_name)
    case role_name.to_sym
    when :admin
      _('Administradores')
    end
  end


end
