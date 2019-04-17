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

    if request.host == 'libroelprincipito'
      I18n.locale = :es
    end

    if request.host == 'thelittleprincebook'
      I18n.locale = :en
    end

  end

end