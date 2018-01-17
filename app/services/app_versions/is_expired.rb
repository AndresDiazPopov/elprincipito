class AppVersions::IsExpired

  def self.call(app_version:)
    # Se comprueba que no sea nula la versión, porque si es nula
    # se devuelve false
    !app_version.nil? && !app_version.expired_at.nil? && Time.now > app_version.expired_at
  end

end