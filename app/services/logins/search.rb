class Logins::Search

  def self.call(states: nil, user: nil, device_manufacturer: nil)
    logins = Login.all
    
    logins = logins.where(user: user) if user

    logins = logins.where(state: states) if states

    logins = logins.joins(device: {device_model: :device_manufacturer})
      .where(device_manufacturers: {id: device_manufacturer}) if device_manufacturer

    logins
  end

end