class DeviceManufacturer < ActiveRecord::Base

  has_many :device_models, dependent: :destroy

  validates_presence_of :name
  
end
