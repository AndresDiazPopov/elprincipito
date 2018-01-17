class Logins::Create

  def self.call(login_params:, device_params:)
    Login.transaction do
      device = Devices::CreateOrUpdate.call(
        unique_identifier: device_params[:unique_identifier],
        mobile_operating_system_name: device_params[:mobile_operating_system_name],
        mobile_operating_system_version_name: device_params[:mobile_operating_system_version_name],
        device_manufacturer_name: device_params[:device_manufacturer_name],
        device_model_name: device_params[:device_model_name],
        user: login_params[:user]
        )
      login_params[:device] = device
      login_params[:mobile_operating_system_version] = device.mobile_operating_system_version

      # Si viene este parámetro, se establece. Sino, no se hace nada (backwards compatibility)
      if login_params[:app_version_name]
        # Si no existe la versión de la app, la crea
        app_version = AppVersion.find_or_create_by(
          name: login_params[:app_version_name],
          mobile_operating_system: device.mobile_operating_system_version.mobile_operating_system)

        # TODO: el servicio debería recibir los parámetros concretos, y no el hash.
        # Mientras, como viene con un parámetro `app_version_name`, hay que cambiarlo
        login_params[:app_version] = app_version
      end
        
      login_params.delete(:app_version_name)

      login = Login.new(login_params)
      login.save!
      login
    end
  end

end