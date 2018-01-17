module API
  module V1
    class Identities < Grape::API

      include API::V1::Defaults

      resource :identities do

        desc "Links a provider to the current user", {
          success: API::V1::Entities::UserWithAccount,
          failure: [
            { code: 409, message: '105: If this user has already an identity with that provider' },
            { code: 401, message: '101: Not authorized' }
          ]
        }
        params do
          use :common_parameters
          use :requires_api_key
          use :requires_provider_name
          use :requires_provider_uid
          use :requires_provider_token
          # use :optional_provider_token_secret
        end
        post :create, with: API::V1::Entities::Identity do
          authenticate!
          begin
            ::Users::LinkProvider.call(
              user: current_user, 
              provider_name: params[:provider_name],
              provider_uid: params[:provider_uid],
              provider_token: params[:provider_token],
              provider_token_secret: params[:provider_token_secret]
            )
          rescue ::Exceptions::DuplicatedEntityError
            already_exists!(Identity, "This user has already an identity with that provider")
          rescue ::Exceptions::AlreadyLinkedToAnotherUserError
            already_exists!(Identity, "This identity is already linked to another user")
          end
          present current_user.reload, with: API::V1::Entities::UserWithAccount
        end

        desc "Unlinks a provider from the current user", {
          success: API::V1::Entities::UserWithAccount,
          failure: [
            { code: 401, message: '101: Wrong api key' },
            { code: 404, message: '103: If the identity does not exist' }
          ]
        }
        params do
          use :common_parameters
          use :requires_api_key
          use :requires_provider_name
        end
        post :delete do
          authenticate!
          begin
            ::Users::UnlinkProvider.call(
              user: current_user, 
              provider_name: params[:provider_name]
            )
            present current_user, with: API::V1::Entities::UserWithAccount
          rescue ::Exceptions::NotFoundError
            not_found!(Identity)
          rescue ::Exceptions::OnlyLinkedToThisProviderError
            forbidden!("This user only has this identity as login method (does not have set neither email/password nor any other identity)")
          end
        end

      end

    end
  end
end