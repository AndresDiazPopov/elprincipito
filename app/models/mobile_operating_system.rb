class MobileOperatingSystem < ActiveRecord::Base

  has_many :mobile_operating_system_version, dependent: :destroy
  has_many :devices, dependent: :destroy
  
  scope :android, -> { where(name: 'android' ) }
  scope :ios, -> { where(name: 'ios' ) }

  validates_presence_of :name

end
