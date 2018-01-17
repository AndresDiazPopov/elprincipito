module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      def self.pagination_desc
        "Uses pagination (pagination info goes in header response): 'x-prev-page', 'x-total', 'x-per-page', 'x-offset', 'x-next-page', 'x-total-pages', 'x-page'"
      end
      
      included do

        include Grape::Kaminari

        prefix 'v1'

        version 'v1', using: :header, vendor: ENV['APP_NAME']
        
        format :json

        rescue_from :all
        error_formatter :json, API::V1::ErrorFormatter

        rescue_from API::V1::Exceptions::APIException do |e|
          error!(e, e.status_code)
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error!({:exception => {
            :code => API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found], 
            :message => "Entity not found"
            }}, API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found])
        end

        before do
          set_locale
        end

        after do
          log_logged_api_request
        end

        helpers do

          # Parámetros comunes a todas las peticiones
          params :common_parameters do
            optional :locale, :type => String, default: 'es_ES', :desc => "Language of texts in responses"
            # Es nulo en peticiones de login o registro
            optional :login_code, :type => String, :desc => "Código de la sesión, obtenido en los users/login_XXX o users/create"
            optional :latitude, type: Float, desc: 'Localización del usuario'
            optional :longitude, type: Float, desc: 'Localización del usuario'
            all_or_none_of :latitude, :longitude
            optional :network_type, type: String, values: Login.network_types.keys, desc: 'Tipo de red de datos a la que se está conectado'
            optional :ssid, type: String, desc: 'En caso de estar en Wi-Fi, SSID de la misma'
          end

          params :device_parameters do
            requires :device_unique_identifier, type: String, desc: 'Identificador único de dispositivo'
            requires :mobile_operating_system_name, type: String, desc: 'Nombre del sistema operativo ("Android", "iOS"...)'
            requires :mobile_operating_system_version_name, type: String, desc: 'Versión del sistema operativo ("4.1, 7.1...")'
            requires :device_manufacturer_name, type: String, desc: 'Nombre del fabricante ("Samsung", "Apple"...)'
            requires :device_model_name, type: String, desc: 'Modelo del dispositivo ("S6", "iPhone 6"...)'
          end

          params :login_parameters do
            optional :app_version_name, type: String, desc: 'Versión de la app (1.0.3, etc.)'
          end

          params :optional_api_key do
            optional :api_key, :type => String
          end

          params :requires_api_key do
            requires :api_key, :type => String
          end

          params :requires_provider_name do
            requires :provider_name, :type => String, :values => ['twitter', 'facebook', 'google_oauth2'], desc: "Name of the provider"
          end

          params :requires_provider_uid do
            requires :provider_uid, :type => String, desc: "UID of the provider"
          end

          params :requires_provider_token do
            requires :provider_token, :type => String, desc: "Access token of the provider"
          end

          params :optional_provider_token_secret do
            optional :provider_token_secret, :type => String, desc: "Access token secret of the provider"
          end

          params :requires_device_token do
            requires :device_token, :type => String, desc: "Device token or registration id"
            requires :platform, :type => String, :values => ['iphone', 'ipad', 'android-mobile', 'android-tablet'], desc: "Type of device"
            requires :platform_version, :type => String, desc: "Version of the platform"
          end

          # Registra una petición al API de un usuario logueado
          # (espera encontrar el login_code entre los params)
          # Se llama automáticamente en el bloque `before do ... end`
          def log_logged_api_request
            if !params[:login_code].blank?
              ApiRequests::Create.call(api_request_params: {
                path: request.path, 
                params: params.to_hash,
                login: Login.find_by(code: params[:login_code]),
                user: current_user, 
                ip: request.ip,
                network_type: params[:network_type],
                ssid: params[:ssid],
                latitude: params[:latitude],
                longitude: params[:longitude]
                })
            end
          end

          # Registra una petición al API asociada al login_code indicado
          def log_not_logged_api_request(user:, login:)
            ApiRequests::Create.call(api_request_params: {
              path: request.path, 
              params: params.to_hash,
              login: login,
              user: user, 
              ip: request.ip,
              network_type: params[:network_type],
              ssid: params[:ssid],
              latitude: params[:latitude],
              longitude: params[:longitude]
              })
          end

          def set_locale
            if params[:locale]
              locale_language = params[:locale].split('_')[0]
            else
              locale_language = 'en'
            end
            I18n.locale = locale_language
          end

          def login_params
            if params[:locale]
              locale_language = params[:locale].split('_')[0]
              locale_country = params[:locale].split('_')[1]
            else
              locale_language = 'es'
              locale_country = 'ES'
            end
            {
              network_type: params[:network_type],
              ip: request.ip,
              ssid: params[:ssid],
              latitude: params[:latitude],
              longitude: params[:longitude],
              locale_language: locale_language,
              locale_country: locale_country,
              app_version_name: params[:app_version_name]
            }
          end

          def device_params
            {
              unique_identifier: params[:device_unique_identifier],
              mobile_operating_system_name: params[:mobile_operating_system_name], 
              mobile_operating_system_version_name: params[:mobile_operating_system_version_name],
              device_manufacturer_name: params[:device_manufacturer_name],
              device_model_name: params[:device_model_name]
            }
          end

          def unauthorized!
            raise API::V1::Exceptions::APIException.new(
              :status_code => API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:unauthorized], 
              :exception_code => API::V1::Exceptions::APIException::EXCEPTION_CODES[:unauthorized], 
              :message => "Unauthorized")
          end

          def forbidden!(message = nil)
            raise API::V1::Exceptions::APIException.new(
              :status_code => API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:forbidden], 
              :exception_code => API::V1::Exceptions::APIException::EXCEPTION_CODES[:forbidden], 
              :message => message ? message : "Forbidden")
          end

          def server_error!(message = nil)
            raise API::V1::Exceptions::APIException.new(
              :status_code => API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:server_error], 
              :exception_code => API::V1::Exceptions::APIException::EXCEPTION_CODES[:server_error], 
              :message => message ? message : "Server error")
          end

          def not_found!(klass = nil)
            raise API::V1::Exceptions::APIException.new(
              :status_code => API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:not_found], 
              :exception_code => API::V1::Exceptions::APIException::EXCEPTION_CODES[:not_found], 
              :message => klass ? (klass.name + " not found") : "Entity not found" )
          end

          def already_exists!(klass, message = nil)
            raise API::V1::Exceptions::APIException.new(
              :status_code => API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:conflict], 
              :exception_code => API::V1::Exceptions::APIException::EXCEPTION_CODES[:already_exists], 
              :message => message ? message : (klass.name + " already exists"))
          end

          def reset_password_code_expired!
            raise API::V1::Exceptions::APIException.new(
              :status_code => API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:forbidden], 
              :exception_code => API::V1::Exceptions::APIException::EXCEPTION_CODES[:reset_password_code_expired], 
              :message => "Reset password code has expired")
          end

          def disabled_user!
            raise API::V1::Exceptions::APIException.new(
              :status_code => API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:forbidden], 
              :exception_code => API::V1::Exceptions::APIException::EXCEPTION_CODES[:disabled_user], 
              :message => "The user is disabled")
          end

          def app_version_expired!(message)
            raise API::V1::Exceptions::APIException.new(
              :status_code => API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:unauthorized], 
              :exception_code => API::V1::Exceptions::APIException::EXCEPTION_CODES[:app_version_expired], 
              :message => message)
          end

          def success!(message = nil)
            status API::V1::Exceptions::APIException::HTTP_STATUS_CODES[:success]
            API::V1::Entities::Success.represent({
              :status => :success,
              :message => message ? message : "Operation succeded"
            }).as_json
          end

          def authenticate!
            unauthorized! unless current_user
          end

          def logger
            Grape::API.logger
          end

          def current_user
            @current_user ||= User.where( :api_key => params[:api_key]).first
          end
          
        end
      end

    end
  end
end