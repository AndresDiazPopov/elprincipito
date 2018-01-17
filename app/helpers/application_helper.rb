module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    is_sort_column = column == params[:sort]
    css_class = is_sort_column ? "current #{sort_direction}" : nil
    direction = is_sort_column && sort_direction == "asc" ? "desc" : "asc"
    title = is_sort_column ? "#{title} <i class='#{direction == "desc" ? "fa fa-chevron-down" : "fa fa-chevron-up"}'></i>".html_safe : title
    link_to title, params.merge({ :sort => column, :direction => direction }), { class: css_class }
  end

  def format_rating(rating)
    rating.to_f.round(1).to_s
  end

  def bootstrap_class_for flash_type
    case flash_type.to_sym
      when :success
        "alert-success" # Green
      when :error
        "alert-danger" # Red
      when :alert
        "alert-warning" # Yellow
      when :notice
        "alert-info" # Blue
      else
        flash_type.to_s
    end
  end

  def badge_css_class(object_class:, state:)
    case object_class.name

    when 'AdminUser'
      case state
      when 'enabled'
        return 'primary'
      when 'disabled'
        return 'default'
      end

    when 'Login'
      case state
      when 'requested'
        return 'default'
      when 'authorized'
        return 'info'
      when 'denied'
        return 'warning'
      end

    when 'User'
      case state
      when 'enabled'
        return 'primary'
      when 'disabled'
        return 'default'
      end

    end

  end

end

module ActionView
  module Helpers
    class FormBuilder
      def globalize_fields_for(locale, *args, &proc)
        raise ArgumentError, "Missing block" unless block_given?

        @locales = {} if @locales.nil?

        if @locales[locale].nil?
          @index = @index ? @index + 1 : 1
        else
          @index = @locales[locale]
        end
        
        @locales[locale] = @index

        object_name = "#{@object_name}[translations_attributes][#{@index}]"
        object = @object.translations.find_by_locale locale.to_s
        @template.concat @template.hidden_field_tag("#{object_name}[id]", object ? object.id : "")
        @template.concat @template.hidden_field_tag("#{object_name}[locale]", locale)
        @template.fields_for(object_name, object, *args, &proc)
      end
    end
  end
end
