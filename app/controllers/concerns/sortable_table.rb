##
# Si se incluye en un controller, hay que implementar el método 
# sortable_columns que debe devolver un array con los nombres de 
# las columnas que se pueden ordenar.
# Para activar la ordenación, las cabeceras de la tabla, en la vista,
# deben estar definidas así:
# <th><%= sortable 'id', _('Id') %></th>
# y el método index del controller así:
# MODEL.where........order(sort_column + ' ' + sort_direction)
#
module SortableTable extend ActiveSupport::Concern

  included do
    helper_method :sort_column, :sort_direction, :default_sort_column
  end

  def sort_column
    sortable_columns.include?(params[:sort]) ? params[:sort] : default_sort_column
  end

  def default_sort_column
    'id'
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

end