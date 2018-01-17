class AdminUser < ActiveRecord::Base
  
  include AASM

  aasm column: :state do

    # Estado normal, inicial. En este estado puede iniciar sesión
    state :enabled, initial: true

    # En este estado no puede iniciar sesión
    state :disabled

    # Habilita un admin_user
    event :enable do
      transitions :from => :disabled, :to => :enabled
    end

    # Deshabilita un admin_user
    event :disable do
      transitions :from => :enabled, :to => :disabled
    end

  end

  enum state: {
    disabled: 0,
    enabled: 1
  }

  has_paper_trail

  acts_as_authorization_subject :role_class_name => 'AdminRole'

  has_many :admin_role_admin_users, dependent: :destroy
  has_many :roles, :class_name => "AdminRole", :through => :admin_role_admin_users, :foreign_key => "admin_user_id", :source => :admin_role, dependent: :destroy

  # Scope para filtrar los admins por rol
  scope :with_role, -> (role) { joins(:roles).where(admin_roles: { name: role }).uniq }
  # Scope para filtrar los admins por roles (filtro OR)
  scope :with_roles, -> (roles) { joins(:roles).where(admin_roles: { name: roles }).uniq }
  
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable,
    :rememberable, :trackable, :validatable, :recoverable

  # Sólo permito login a estos roles
  def active_for_authentication?
    super && self.enabled? && (self.has_role?(:admin))
  end

  validates_presence_of :email, :full_name
  validates_uniqueness_of :email, case_sensitive: false

  # Devuelve el estado en un string válido para mostrar al administrador
  def state_string
    AdminUser.state_string(self.state)
  end

  def self.state_string(state)
    case state.to_s
    when 'enabled'
      _('Habilitado')
    when 'disabled'
      _('Deshabilitado')
    end
  end

end
