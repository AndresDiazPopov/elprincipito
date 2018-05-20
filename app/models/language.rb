class Language < ActiveRecord::Base

  include AASM

  translates :name, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations

  aasm column: :state do

    # Estado normal, inicial
    state :enabled, initial: true

    state :disabled

    event :enable do
      transitions :from => :disabled, :to => :enabled
    end

    event :disable do
      transitions :from => :enabled, :to => :disabled
    end

  end

  enum state: {
    disabled: 0,
    enabled: 1
  }

  def self.state_string(state)
    case state.to_s
    when 'enabled'
      _('Habilitado')
    when 'disabled'
      _('Deshabilitado')
    end
  end
  
  has_paper_trail

  validates_presence_of :name
  validates_uniqueness_of :name

end
