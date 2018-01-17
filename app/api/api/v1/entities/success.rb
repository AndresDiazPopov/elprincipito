module API
  module V1
    module Entities
      class Success < Grape::Entity

        expose :status, documentation: {required: true}
        expose :message, documentation: {required: true}

      end
    end
  end
end