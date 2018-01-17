module API
  module V1
    module Entities
      class Identity < Grape::Entity

        root 'identities', 'identity'

        expose :id, documentation: {type: :integer, required: true}
        expose :uid, documentation: {required: true}
        expose :provider, documentation: {required: true}
        expose :token, documentation: {required: true}
        expose :token_secret, documentation: {required: false}
      end
    end
  end
end