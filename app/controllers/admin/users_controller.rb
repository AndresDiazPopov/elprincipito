class Admin::UsersController < Admin::AdminController

  include SortableTable

  add_breadcrumb _('Administradores'), :admin_users_path

  def index
    authorize User
    @text = params[:text] if !params[:text].blank?
    @state = params[:state] if !params[:state].blank?
    @users = ::Users::Search.call(text: @text, state: @state)
      .page(params[:page])
      .order(sort_column + ' ' + sort_direction)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @user = ::Users::Find.call(id: params[:id])
    authorize @user
    add_breadcrumb @user.email, admin_user_path(@user)
  end

  def enable
    @user = Users::Find.call(id: params[:id])
    authorize @user
    change_state(user: @user,
      service: Users::Enable, 
      error_title: _('No se puede habilitar este administrador.'), 
      success_title: _('Administrador habilitado.'))
  end

  def disable
    @user = Users::Find.call(id: params[:id])
    authorize @user
    change_state(user: @user,
      service: Users::Disable, 
      error_title: _('No se puede deshabilitar este administrador.'), 
      success_title: _('Administrador deshabilitado.'))
  end

  private

    def sortable_columns
      %w[id email state created_at]
    end

    def change_state(user:, service:, error_title:, success_title:)
      @user = user
      if service.call(user: user)
        @success_title = success_title
        respond_to do |format|
          format.js { render template: 'admin/users/state_changed' }
          format.html
        end
      else
        respond_to do |format|
          @error_title = error_title
          format.js { render template: 'admin/shared/alerts/error' }
          format.html
        end
      end
    end

end