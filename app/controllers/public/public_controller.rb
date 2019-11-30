class Public::PublicController < ApplicationController
  before_action :set_locale_according_to_domain

  protected

    def layout_by_resource
      if devise_controller?
        "public/devise"
      else
        "public/application"
      end
    end

  private

  def set_locale_according_to_domain

    I18n.locale = :es if request.host == 'libroelprincipito.com'

    I18n.locale = :en if request.host == 'thelittleprincebook.com'

    I18n.locale = params[:locale] if params[:locale]

  end

end