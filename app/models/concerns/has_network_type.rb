module HasNetworkType
  extend ActiveSupport::Concern

  included do
    
    enum network_type: { network_unknown: 0, network_wifi: 1, network_mobile_data: 2 }

    def network_type_string
      case self.network_type
      when 'network_unknown'
        _('Desconocido')
      when 'network_wifi'
        _('Wi-Fi')
      when 'network_mobile_data'
        _('Datos móviles')
      end
    end

  end

end