class Public::PublicController < ApplicationController

  protected

    def layout_by_resource
      if devise_controller?
        "public/devise"
      else
        "public/application"
      end
    end

end