module API
  module V1
    class Base < Grape::API

      format :json

      # mount API::V1::Devices
      mount API::V1::Identities
      mount API::V1::Users

      add_swagger_documentation base_path: '/api',
                                api_version: 'v1',
                                hide_documentation_path: true,
                                mount_path: 'docs/v1/api-docs.json'

      route :any, '*path' do
        error! "API endpoint not found", 404
      end

    end
  end
end