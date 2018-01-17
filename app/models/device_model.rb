class DeviceModel < ActiveRecord::Base

  belongs_to :device_manufacturer
  has_many :devices, dependent: :destroy
  
  validates_presence_of :device_manufacturer, :name
end
