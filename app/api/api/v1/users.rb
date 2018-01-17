module API
  module V1
    class Users < Grape::API

      include API::V1::Defaults

      helpers do

        params :optional_provider_name do
          optional :provider_name, :type => String, :values => ['twitter', 'facebook', 'google_oauth2'], desc: "Name of the provider"
        end

        params :optional_provider_uid do
          optional :provider_uid, :type => String, desc: "UID of the provider"
        end

        params :optional_provider_token do
          optional :provider_token, :type => String, desc: "Access token of the provider"
        end

      end

      resource :users do

        desc "Logs in a user with email and password", {
          success: API::V1::Entities::UserAfterLogin,
          failure: [
            { code: 404, message: '103: If there is no user with that email and password' }
          ]
        }
        params do
          use :common_parameters
          use :device_parameters
          use :login_parameters
          requires :email, type: String, desc: "The email of the user"
          requires :password, type: String, desc: "The (clean) password of the user"
        end
        post :login_with_email do
          begin
            user, login = ::Users::LoginWithEmailAndPassword.call(
              email: params[:email],
              password: params[:password],
              login_params: login_params,
              device_params: device_params)
          rescue ::Exceptions::NotFoundError
            # Registro la petición (no entra por el bloque before del helper
            # porque aún estaría sin usuario)
            log_not_logged_api_request(user: user, login: login)
            not_found!(User)
          rescue ::Exceptions::AppVersionExpiredError => ex
            log_not_logged_api_request(user: user, login: login)
            app_version_expired!(ex.message)
          rescue ::Exceptions::InvalidPasswordError => ex
            log_not_logged_api_request(user: user, login: login)
            not_found!(User)
          end
          
          # Registro la petición (no entra por el bloque before del helper
          # porque aún estaría sin usuario)
          log_not_logged_api_request(user: user, login: login)

          present user, with: API::V1::Entities::UserAfterLogin, login: login
        end

        desc "Logs in a user with the api key", {
          success: API::V1::Entities::UserAfterLogin,
          failure: [
            { code: 404, message: '103: If there is no user with that api key' }
          ]
        }
        params do
          use :common_parameters
          use :device_parameters
          use :login_parameters
          use :requires_api_key
        end
        post :login_with_api_key do
          begin
            user, login = ::Users::LoginWithApiKey.call(
              api_key: params[:api_key],
              login_params: login_params,
              device_params: device_params)
          rescue ::Exceptions::NotFoundError
            # Registro la petición (no entra por el bloque before del helper
            # porque aún estaría sin usuario)
            log_not_logged_api_request(user: user, login: login)
            not_found!(User)
          rescue ::Exceptions::AppVersionExpiredError => ex
            app_version_expired!(ex.message)
          end
          
          # Registro la petición (no entra por el bloque before del helper
          # porque aún estaría sin usuario)
          log_not_logged_api_request(user: user, login: login)

          present user, with: API::V1::Entities::UserAfterLogin, login: login
        end

        desc "Logs in a user using the provider data", {
          success: API::V1::Entities::UserAfterLogin,
          failure: [
            { code: 404, message: '103: If there is no user with that provider and uid' }
          ]
        }
        params do
          use :common_parameters
          use :device_parameters
          use :login_parameters
          use :requires_provider_name
          use :requires_provider_uid
          use :requires_provider_token
        end
        post :login_with_identity do
          begin
            user, login = ::Users::LoginWithIdentity.call(
              provider_name: params[:provider_name],
              provider_uid: params[:provider_uid],
              provider_token: params[:provider_token],
              login_params: login_params,
              device_params: device_params)
          rescue ::Exceptions::NotFoundError
            # Registro la petición (no entra por el bloque before del helper
            # porque aún estaría sin usuario)
            log_not_logged_api_request(user: user, login: login)
            not_found!(Identity)
          rescue ::Exceptions::AppVersionExpiredError => ex
            app_version_expired!(ex.message)
          end

          # Registro la petición (no entra por el bloque before del helper
          # porque aún estaría sin usuario)
          log_not_logged_api_request(user: user, login: login)

          present user, with: API::V1::Entities::UserAfterLogin, login: login
        end

        desc "Creates a user", {
          success: API::V1::Entities::UserAfterLogin,
          failure: [
            { code: 403, message: '102: Si hay algún error en la validación'},
            { code: 409, message: '105: If there is a user with that email' }
          ]
        }
        params do
          use :common_parameters
          use :device_parameters
          use :login_parameters
          optional :email, :type => String, desc: "The email of the user"
          optional :password, :type => String, desc: "The (clean) password of the user"
          optional :image, :type => Rack::Multipart::UploadedFile, :desc => "Image file"
          optional :image_url, :type => String, desc: "The URL of the image (must be publicly accessible)"
          mutually_exclusive :image, :image_url
          use :requires_provider_name
          use :requires_provider_uid
          use :requires_provider_token
          use :optional_provider_token_secret
        end
        post :create do
          begin
            image = ActionDispatch::Http::UploadedFile.new(params[:image]) if params[:image]
            user, login = ::Users::Create.call(
              email: params[:email],
              password: params[:password],
              image: image,
              image_url: params[:image_url],
              provider_name: params[:provider_name],
              provider_uid: params[:provider_uid],
              provider_token: params[:provider_token],
              provider_token_secret: params[:provider_token_secret],
              login_params: login_params,
              device_params: device_params)
          rescue ::Exceptions::DuplicatedEntityError
            # Registro la petición (no entra por el bloque before del helper
            # porque aún estaría sin usuario)
            log_not_logged_api_request(user: user, login: login)
            already_exists!(User, "There is a user with that provider and uid, or with that email")
          rescue ::Exceptions::AppVersionExpiredError => ex
            app_version_expired!(ex.message)
          end

          # Registro la petición (no entra por el bloque before del helper
          # porque aún estaría sin usuario)
          log_not_logged_api_request(user: user, login: login)

          # Si hay algún error (de validación, por ejemplo)
          forbidden!(login.denied_reason) if login.denied?

          present user, with: API::V1::Entities::UserAfterLogin, login: login
        end

        desc "Updates a user", {
          success: API::V1::Entities::UserWithAccount,
          failure: [
            { code: 401, message: '101: Wrong api key, or wrong old_password if updating password' }
          ]
        }
        params do
          use :common_parameters
          use :requires_api_key
          optional :old_password, :type => String, desc: "The old password of the user"
          optional :new_password, :type => String, desc: "The new password of the user"
          optional :image, :type => Rack::Multipart::UploadedFile, :desc => "Image file"
          optional :image_url, :type => String, desc: "The URL of the image (must be publicly accessible)"
          mutually_exclusive :image, :image_url
          all_or_none_of :old_password, :new_password
        end
        post :update do
          authenticate!
          begin
            image = ActionDispatch::Http::UploadedFile.new(params[:image]) if params[:image]
            user = ::Users::Update.call(
              user: current_user,
              old_password: params[:old_password],
              new_password: params[:new_password],
              image: image,
              image_url: params[:image_url])
          rescue ::Exceptions::UnauthorizedError
            unauthorized!
          end

          present user, with: API::V1::Entities::UserWithAccount
        end

        desc "Request password reset instructions.", {
          success: API::V1::Entities::Success,
          failure: [
            { code: 404, message: '103: If there is no user with that email' }
          ]
        }
        params do
          use :common_parameters
          requires :email, :type => String, desc: "The email of the user where to send the instructions."
        end
        post :request_password_reset_instructions do
          log_not_logged_api_request(user: nil, login: nil)
          begin
            ::Users::RequestPasswordResetInstructions.call(
              email: params[:email])
          rescue ::Exceptions::NotFoundError
            not_found!(User)
          end
          success!
        end

        desc "Resets the password", {
          success: API::V1::Entities::Success,
          failure: [
            { code: 401, message: '101: If password update goes wrong' },
            { code: 403, message: '104: If code is expired' },
            { code: 404, message: '103: If there is no user with that email' }
          ]
        }
        params do
          use :common_parameters
          requires :email, :type => String, desc: "The email of the user where to send the instructions."
          requires :code, :type => Integer, desc: "The 4 digits code (perishable_code)."
          requires :password, :type => String, desc: "The (clean) password of the user"
        end
        post :reset_password do
          log_not_logged_api_request(user: nil, login: nil)
          begin
            ::Users::ResetPassword.call(
              email: params[:email],
              code: params[:code],
              password: params[:password])
          rescue ::Exceptions::NotFoundError
            not_found!(User)
          rescue ::Exceptions::ResetPasswordCodeExpiredError
            reset_password_code_expired!
          rescue ::Exceptions::UnauthorizedError
            unauthorized!
          end
          success!
        end

        desc "Returns all the details of a user.", {
          success: API::V1::Entities::User,
          failure: [
            { code: 404, message: '103: If there is no user with that id' }
          ]
        }
        params do
          use :common_parameters
          requires :id, :type => Integer, desc: "User id"
          use :optional_api_key
        end
        get :show do
          authenticate!
          present User.find(params[:id]), with: API::V1::Entities::User
        end

        desc "Logs out a user.", {
          success: API::V1::Entities::Success,
          failure: [
            { code: 401, message: '101: Wrong api key' }
          ]
        }
        params do
          use :common_parameters
          use :requires_api_key
        end
        post :logout do
          authenticate!
          ::Users::Logout.call(
            user: current_user)
          success!
        end

        desc "Deletes a user.", {
          success: API::V1::Entities::Success,
          failure: [
            { code: 401, message: '101: Wrong api key' }
          ]
        }
        params do
          use :common_parameters
          use :requires_api_key
        end
        post :delete do
          authenticate!
          ::Users::Delete.call(
            user: current_user)
          success!
        end

      end

    end
  end
end