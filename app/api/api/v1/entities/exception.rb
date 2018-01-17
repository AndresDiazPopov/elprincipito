module API
  module V1
    module Entities
      class Exception < Grape::Entity

        root 'exceptions', 'exception'

        expose :exception_code, as: :code, documentation: {type: :integer, required: true}
        expose :message, documentation: {required: true}
        expose :backtrace, documentation: {required: true}
      end
    end
  end
end