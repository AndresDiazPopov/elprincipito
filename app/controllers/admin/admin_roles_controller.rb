class Admin::AdminRolesController < Admin::AdminController

  add_breadcrumb _('Administradores'), :admin_admin_users_path

  def new
    authorize AdminRole
    @admin_user = AdminUsers::Find.call(id: params[:admin_user_id])
    @admin_role = AdminRole.new
    add_breadcrumb @admin_user.email, admin_admin_user_path(@admin_user)
    add_breadcrumb _('Añadir rol')
  end

  def create
    authorize AdminRole
    @admin_user = AdminUsers::Find.call(id: params[:admin_user_id])
    role = role_params[:name]

    begin
      AdminRoles::Create.call(admin_user: @admin_user, role: role, authorizable_type: nil, authorizable_id: nil)
      redirect_to admin_admin_user_path(@admin_user)
    rescue Exceptions::DuplicatedRoleError
      @admin_role = AdminRole.new(name: role, authorizable_id: nil)
      render :new
    end

  end

  def edit
    @admin_user = AdminUsers::Find.call(id: params[:admin_user_id])
    @admin_role = AdminRole.find(params[:id])
    authorize @admin_role
    add_breadcrumb @admin_user.email, admin_admin_user_path(@admin_user)
    add_breadcrumb _('Editar rol')
  end

  def destroy
    @admin_user = AdminUsers::Find.call(id: params[:admin_user_id])
    @admin_role = AdminRoles::Find.call(id: params[:id])
    authorize @admin_role
    authorizable_id = params[:authorizable_id]
    
    AdminRoles::Delete.call(
      admin_user: @admin_user,
      role: @admin_role.name,
      authorizable_id: authorizable_id)
    respond_to do |format|
      format.js
    end
  end

  private

    def role_params
      params.require(:admin_role).permit(:name)
    end

end