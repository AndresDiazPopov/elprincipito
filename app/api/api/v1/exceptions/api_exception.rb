module API
  module V1
    module Exceptions
      class APIException < StandardError

        include ActiveModel::Serialization

        attr_accessor :status_code, :exception_code, :message, :backtrace

        HTTP_STATUS_CODES = {
          :success => 200,
          :unauthorized => 401,
          :forbidden => 403,
          :not_found => 404,
          :not_acceptable => 406,
          :conflict => 409,
          :unprocessable_entity => 422,
          :server_error => 500
        }

        # 10X reservados para cosas generales
        # Los propios de la app, 20X
        EXCEPTION_CODES = {
          :server_error => 100,
          :unauthorized => 101,
          :forbidden => 102,
          :not_found => 103,
          :reset_password_code_expired => 104,
          :already_exists => 105,
          :disabled_user => 109,
          :app_version_expired => 113
        }

        def initialize(params = {})
          super
          @status_code = params[:status_code]
          @exception_code = params[:exception_code]
          @message = params[:message]
          @backtrace = params[:backtrace]
        end
      end
    end
  end
end