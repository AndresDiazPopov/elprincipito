Rails.application.routes.draw do

  # Rutas para devise (login, logout y otras) de admins
  devise_for :admin_users, path: 'admin', path_names: { sign_in: 'login', sign_out: 'logout'}

  # Panel de administración
  authenticated :admin_user do

    namespace :admin do

      root to: "dashboard#dashboard", as: :dashboard

      resources :users, only: [:index, :show] do

        member do
          put :enable
          put :disable
        end
        
      end

      resources :admin_users do

        resources :admin_roles

        member do
          put :enable
          put :disable

          get :edit_password
          put :update_password

          put :add_role
        end

        collection do
          get :find_by_email
        end
        
      end

      resources :logins, only: [:index, :show]

      resources :api_requests, only: [:index, :show]

      resources :devices, only: [:index]

    end

  end

  # DESCOMENTAR SI SE QUIERE PERMITIR INICIAR SESIÓN EN LA WEB A LOS USUARIOS NORMALES
  # Rutas para devise (login, logout y otras) de usuarios
  devise_for :users, path: 'public', path_names: { sign_in: 'login', sign_out: 'logout'}

  # Páginas públicas, pero sin el "public/"" en la URL
  scope module: 'public' do
    get 'terms-and-conditions' => 'static#terms_and_conditions', :as => :terms_and_conditions
    get 'privacy-policy' => 'static#privacy_policy', :as => :privacy_policy
  end

  # DESCOMENTAR SI HAY PANEL Y TAMBIÉN WEB PÚBLICA
  # Por defecto, el root es la página pública
  root to: "public/static#index"

  # DESCOMENTAR SI SOLO HAY PANEL Y NO HAY WEB PÚBLICA
  # Si solo hay panel, la raíz lleva directamente al login del panel
  # as :admin_user do
  #   root to: "devise/sessions#new"
  # end

  # Monta el API
  mount API::Base => '/api'

  # Redirige las URLs inexistentes
  get '/admin/*path' => redirect('/admin')
  get '*path' => redirect('/')

end
