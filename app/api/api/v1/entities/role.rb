module API
  module V1
    module Entities
      class Role < Grape::Entity

        root 'roles', 'role'

        expose :name, as: :role, documentation: {required: true}
      end
    end
  end
end