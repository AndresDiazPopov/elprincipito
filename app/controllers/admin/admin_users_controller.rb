class Admin::AdminUsersController < Admin::AdminController

  include SortableTable

  add_breadcrumb _('Administradores'), :admin_admin_users_path

  def index
    authorize AdminUser
    @role = params[:role] if !params[:role].blank?
    @text = params[:text] if !params[:text].blank?
    @state = params[:state] if !params[:state].blank?
    @admin_users = ::AdminUsers::Search.call(
      text: @text, state: @state, role: @role)
      .page(params[:page])
      .order(sort_column + ' ' + sort_direction)

    @admin_users = policy_scope(@admin_users)
    
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @admin_user = ::AdminUsers::Find.call(id: params[:id])
    authorize @admin_user
    add_breadcrumb @admin_user.email, admin_admin_user_path(@admin_user)
  end

  def new
    add_breadcrumb _('Nuevo')
    @admin_user = AdminUser.new

    if params[:role]
      case params[:role]
      when 'admin'
        authorize AdminUser, :new_admin?
        render :new_admin
      end
    end
  end

  def create
    # Cachea la plantilla para volver al sitio correcto en caso de error
    new_template = nil
    case params[:role]
    when 'admin'
      authorize AdminUser, :create_admin?
      new_template = :new_admin
      authorizable_type = nil
    end

    @admin_user = AdminUsers::Create.call(
      admin_user_params: admin_user_params,
      role: params[:role],
      authorizable_type: authorizable_type,
      authorizable_id: params[:authorizable_id])

    if !@admin_user.errors.any?
      flash[:success] = _('Administrador creado')
      case params[:role]
      when 'admin'
        redirect_to admin_admin_user_path(@admin_user)
      end
    else
      render new_template
    end
  end

  def add_role
    # Cachea la plantilla para volver al sitio correcto en caso de error
    new_template = nil
    @admin_user = AdminUsers::Find.call(id: params[:id])
    case params[:role]
    when 'admin'
      authorize @admin_user, :add_role_admin?
      new_template = :new_admin
    end

    begin
      AdminRoles::Create.call(
        admin_user: @admin_user, 
        role: params[:role],
        authorizable_type: nil,
        authorizable_id: params[:authorizable_id])

      redirect_to admin_admin_user_path(@admin_user)
    rescue Exceptions::DuplicatedRoleError
      render new_template
      return
    end
  end

  def edit
    @admin_user = ::AdminUsers::Find.call(id: params[:id])
    authorize @admin_user
    add_breadcrumb @admin_user.email, admin_admin_user_path(@admin_user)
    add_breadcrumb _('Editar')
  end

  def update
    @admin_user = ::AdminUsers::Find.call(id: params[:id])
    authorize @admin_user

    @admin_user = AdminUsers::Update.call(admin_user: @admin_user, admin_user_params: admin_user_params)

    if !@admin_user.errors.any?
      flash[:success] = _('Administrador modificado')
      redirect_to admin_admin_user_path(@admin_user)
    else
      render :edit
    end
  end

  def edit_password
    @admin_user = ::AdminUsers::Find.call(id: params[:id])
    authorize @admin_user
    add_breadcrumb @admin_user.email, admin_admin_user_path(@admin_user)
    add_breadcrumb _('Cambiar password')
  end

  def update_password
    @admin_user = ::AdminUsers::Find.call(id: params[:id])
    authorize @admin_user

    @admin_user = AdminUsers::UpdatePassword.call(admin_user: @admin_user, admin_user_params: update_password_params)

    if !@admin_user.errors.any?
      bypass_sign_in(@admin_user)
      flash[:success] = _('Contraseña cambiada')
      redirect_to admin_admin_user_path(@admin_user)
    else
      render :edit_password
    end
  end

  def enable
    @admin_user = AdminUsers::Find.call(id: params[:id])
    authorize @admin_user
    change_state(admin_user: @admin_user,
      service: AdminUsers::Enable, 
      error_title: _('No se puede habilitar este administrador.'), 
      success_title: _('Administrador habilitado.'))
  end

  def disable
    @admin_user = AdminUsers::Find.call(id: params[:id])
    authorize @admin_user
    change_state(admin_user: @admin_user,
      service: AdminUsers::Disable, 
      error_title: _('No se puede deshabilitar este administrador.'), 
      success_title: _('Administrador deshabilitado.'))
  end

  def find_by_email
    authorize AdminUser
    @admin_user = AdminUsers::FindByEmail.call(email: params[:email])
    respond_to do |format|
      format.js { render status: 200, template: 'admin/admin_users/found_admin_user' }
    end
  end

  private

    def admin_user_params
      params.require(:admin_user).permit(
        :email,
        :full_name
        )
    end

    def update_password_params
      params.require(:admin_user).permit(
        :current_password,
        :password,
        :password_confirmation
        )
    end

    def sortable_columns
      %w[id email full_name state created_at]
    end

    def change_state(admin_user:, service:, error_title:, success_title:)
      @admin_user = admin_user
      if service.call(admin_user: admin_user)
        @success_title = success_title
        respond_to do |format|
          format.js { render template: 'admin/admin_users/state_changed' }
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