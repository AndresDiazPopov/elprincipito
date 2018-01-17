class Admin::DevicesController < Admin::AdminController

  include SortableTable

  add_breadcrumb _('Dispositivos'), :admin_devices_path

  def index
    authorize Device
    @user_id = params[:user_id] if !params[:user_id].blank?
    @device_manufacturer_id = params[:device_manufacturer_id] if !params[:device_manufacturer_id].blank?
    @mobile_operating_system_id = params[:mobile_operating_system_id] if !params[:mobile_operating_system_id].blank?
    @devices = ::Devices::Search.call(
      user: @user_id,
      device_manufacturer: @device_manufacturer_id,
      mobile_operating_system: @mobile_operating_system_id)
      .page(params[:page])
      .includes(:user, {device_model: :device_manufacturer}, {mobile_operating_system_version: :mobile_operating_system})
      .order(sort_column + ' ' + sort_direction)
    respond_to do |format|
      format.js
      format.html
    end
  end

  private

    def sortable_columns
      %w[devices.id users.email device_manufacturers.name mobile_operating_systems.name mobile_operating_system_versions.name created_at]
    end

    def default_sort_column
      'devices.id'
    end

end