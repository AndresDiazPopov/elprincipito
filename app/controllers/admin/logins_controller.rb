class Admin::LoginsController < Admin::AdminController

  include SortableTable

  add_breadcrumb _('Logins'), :admin_logins_path

  def index
    authorize Login
    @user_id = params[:user_id] if !params[:user_id].blank?
    @device_manufacturer_id = params[:device_manufacturer_id] if !params[:device_manufacturer_id].blank?
    @states = [Login.states[params[:state]]] if !params[:state].blank?
    @logins = ::Logins::Search.call(
      states: @states,
      user: @user_id,
      device_manufacturer: @device_manufacturer_id)
      .page(params[:page])
      .includes(:user, {device: {device_model: :device_manufacturer}})
      .order(sort_column + ' ' + sort_direction)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @login = Login.find(params[:id])
    authorize @login
    add_breadcrumb @login.id.to_s, admin_login_path(@login)
  end

  private

    def sortable_columns
      %w[logins.id users.email device_manufacturers.name ip network_type state created_at]
    end

    def default_sort_column
      'logins.id'
    end

end