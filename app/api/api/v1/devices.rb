module API
  module V1
    class Devices < Grape::API

      include API::V1::Defaults

      resource :devices do

        desc "Creates a device, or updates the existing one. Looks for a device \
          with the specified device_token. If found, it updates it with the \
          provided data. Either creating or updating, if api_key is provided, \
          the device is attached to the user. If not, the device's user is set \
          to nil", {
          success: API::V1::Entities::Success,
          failure: [
            { code: 401, message: '101: Wrong api key' }
          ]
        }
        params do
          use :common_parameters
          use :optional_api_key
          # use :requires_device_token
        end
        post :create do
          # authenticate!
          # ::Devices.CreateOrUpdate.call(
          #   user: current_user,
          #   device_token: params[:device_token],
          #   platform: params[:platform],
          #   platform_version: params[:platform_version])
          success!
        end

      end

    end
  end
end