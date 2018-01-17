class Login < ActiveRecord::Base

  include HasNetworkType

  include AASM

  aasm column: :state do

    # Estado inicial
    state :requested, initial: true

    # Si no se deja iniciar sesión
    state :authorized

    # Si no se deja iniciar sesión
    state :denied

    # Autoriza un login
    event :authorize do
      transitions from: :requested, to: :authorized
    end

    # Deniega un login
    event :deny do
      transitions from: :requested, to: :denied
    end

  end

  enum state: {
    requested: 0,
    authorized: 1,
    denied: 2
  }

  def state_string
    Login.state_string(self.state)
  end

  def self.state_string(state)
    case state.to_s
    when 'requested'
      _('Solicitado')
    when 'authorized'
      _('Autorizado')
    when 'denied'
      _('Denegado')
    end
  end

  belongs_to :user
  belongs_to :device
  belongs_to :mobile_operating_system_version
  belongs_to :app_version

  # Cambios de estado (se guardan en su propio modelo, con comentarios)
  has_many :api_requests, dependent: :destroy

  validates_presence_of :state, :ip, :network_type, :locale_language, :locale_country
  validates_presence_of :denied_reason, if: lambda { self.denied? }
  validates_absence_of :denied_reason, if: lambda { !self.denied? }
  validates_uniqueness_of :code

  # Lo lanza antes de la validación
  before_validation :generate_and_set_code

  def generate_and_set_code
    if self.code.nil?
      loop do
        token = Devise.friendly_token
        break self.code = token unless Login.where(code: token).first
      end
    end
  end
  
end
