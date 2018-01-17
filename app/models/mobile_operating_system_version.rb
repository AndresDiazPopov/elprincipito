class MobileOperatingSystemVersion < ActiveRecord::Base

  belongs_to :mobile_operating_system
  has_many :logins, dependent: :destroy

  validates_presence_of :mobile_operating_system, :name

end
