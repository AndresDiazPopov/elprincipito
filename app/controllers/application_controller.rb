class ApplicationController < ActionController::Base

  layout :layout_by_resource

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_gettext_locale

  # Para devise en general
  def after_sign_in_path_for(user)
    user.class.name == 'AdminUser' ? admin_dashboard_path : root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def user_for_paper_trail
    if user_signed_in?
      current_user.try(:id)
    elsif admin_user_signed_in?
      current_admin_user.try(:id)
    else
      'Unknown user'
    end
  end

  protected

    def layout_by_resource
      if devise_controller?
        if resource_name == :admin_user
          "admin/devise"
        else
          "public/devise"
        end
      else
        if resource_name == :admin_user
          "admin/application"
        else
          "public/application"
        end
      end
    end

end
