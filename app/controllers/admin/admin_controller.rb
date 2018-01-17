class Admin::AdminController < ApplicationController

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :admin_user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from Exceptions::NotFoundError, :with => :record_not_found

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :sign_out_if_not_active_for_authentication
  before_action :set_locale
  
  after_action :verify_authorized

  def set_locale
      I18n.locale = params[:locale] || :es
  end

  def pundit_user
    current_admin_user
  end

  # Cierra sesión automáticamente si el usuario ya no está activo
  def sign_out_if_not_active_for_authentication
    sign_out if current_admin_user && !current_admin_user.active_for_authentication?
  end

  private

    def admin_user_not_authorized
      flash[:alert] = _('No estás autorizado a realizar esta acción')
      redirect_to(request.referrer || admin_dashboard_path)
    end

    def record_not_found
      flash[:alert] = _('Elemento no encontrado')
      redirect_to(request.referrer || admin_dashboard_path)
    end

  protected

    def layout_by_resource
      if devise_controller?
        "admin/devise"
      else
        "admin/application"
      end
    end
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:image])
    end

end