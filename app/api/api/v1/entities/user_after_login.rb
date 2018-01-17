module API
  module V1
    module Entities
      class UserAfterLogin < API::V1::Entities::UserWithAccount

        expose :login_code, documentation: {required: true, desc: 'El código de la sesión, a usar en las llamadas subsiguientes'}
        
        def login_code
          options[:login].try(:code)
        end

      end
    end
  end
end