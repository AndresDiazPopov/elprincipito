module API
  module V1
    module ErrorFormatter

      def self.call message, backtrace, options, env
        if message.is_a?(API::V1::Exceptions::APIException)
          message.backtrace = backtrace if Rails.env.development?
        else
          message = {
            exception_code: message.is_a?(Hash) ? message[:exception][:code] : 500, 
            message: message.is_a?(Hash) ? message[:exception][:message] : message, 
            backtrace: Rails.env.development? ? backtrace : nil}
        end
        API::V1::Entities::Exception.represent(message).to_json
      end
    end
  end
end