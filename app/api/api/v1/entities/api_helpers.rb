module API
  module V1
    module Entities
      module ApiHelpers
        
        Grape::Entity.format_with :time_format do |date|
          date.strftime("%d/%m/%Y %H:%M:%S") if date
        end

        Grape::Entity.format_with :image_url_format do |image_url|
          if image_url
            if ENV["s3_active"] == "true"
              image_url
            else
              options[:env]['rack.url_scheme'] + '://' + options[:env]['HTTP_HOST'] + image_url
            end
          end
        end

      end
    end
  end
end