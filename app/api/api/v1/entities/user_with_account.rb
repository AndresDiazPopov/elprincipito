module API
  module V1
    module Entities
      class UserWithAccount < API::V1::Entities::User

        expose :email, documentation: {required: false}
        expose :api_key, documentation: {required: true}
        expose :roles, using: API::V1::Entities::Role, documentation: {is_array: true, required: true}
        
        expose :identities, using: API::V1::Entities::Identity, documentation: {is_array: true, required: true}

      end
    end
  end
end