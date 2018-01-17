class User < ActiveRecord::Base
  
  include AASM

  aasm column: :state do

    # Estado normal. En este estado puede hacer liquidaciones y/o operaciones
    state :enabled, initial: true

    # En este estado no aparece en la app.
    state :disabled

    # Habilita un usuario
    event :enable do
      transitions :from => :disabled, :to => :enabled
    end

    # Deshabilita un usuario
    event :disable do
      transitions :from => :enabled, :to => :disabled
    end

  end

  enum state: {
    disabled: 0,
    enabled: 1
  }

  # Devuelve el estado en un string válido para mostrar al usuario
  def state_string
    User.state_string(self.state)
  end

  def self.state_string(state)
    case state.to_s
    when 'enabled'
      _('Habilitado')
    when 'disabled'
      _('Deshabilitado')
    end
  end

  has_paper_trail

  acts_as_authorization_subject

  attr_accessor :provider_temp_image_url

  has_many :roles_users, dependent: :destroy
  has_many :roles, :class_name => "Role", :through => :roles_users, :foreign_key => "user_id", :source => :role, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :devices, dependent: :destroy

  has_many :logins, dependent: :destroy
  has_many :api_requests, dependent: :destroy

  # Lo lanza antes de la validación
  before_validation :generate_and_set_api_key

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable

  def password_required?
    false
  end

  def email_required?
    false
  end

  has_attached_file :image, styles: { 
    thumb: "100x100#" },
    default_url: 'DefaultUserImage.png'
  validates_attachment :image,
    content_type: { content_type: /\Aimage\/.*\Z/ },
    size: { in: 0..1000.kilobytes }

  # Tiene que tener al menos una identity para poder omitir email o password
  validates_presence_of :identities, unless: lambda { !self.email.blank? && !self.encrypted_password.blank? }
  validates_presence_of :email, if: lambda { !self.encrypted_password.nil? }
  validates_uniqueness_of :email, :allow_blank => true
  validates_presence_of :api_key
  validates_uniqueness_of :api_key
  
  def generate_and_set_api_key
    if self.api_key.nil?
      loop do
        token = Devise.friendly_token
        break self.api_key = token unless User.where(api_key: token).first
      end
    end
  end

end
