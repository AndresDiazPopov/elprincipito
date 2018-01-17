class AppVersion < ActiveRecord::Base

  translates :expired_message

  belongs_to :mobile_operating_system

  validates_presence_of :name, :mobile_operating_system
  validates_uniqueness_of :name, scope: :mobile_operating_system

end
