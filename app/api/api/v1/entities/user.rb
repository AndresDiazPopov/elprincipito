module API
  module V1
    module Entities
      include ApiHelpers
      class User < Grape::Entity

        root 'users', 'user'

        expose :id, documentation: {type: :integer, required: true}
        expose :image_thumb_url, format_with: :image_url_format, documentation: {required: true}
        expose :image_url, format_with: :image_url_format, documentation: {required: true}
        
        def image_thumb_url
          object.image.url(:thumb) if !object.image_file_size.nil?
        end

        def image_url
          object.image.url if !object.image_file_size.nil?
        end
        
      end
    end
  end
end