class Device < ActiveRecord::Base

  has_paper_trail

  belongs_to :user
  belongs_to :mobile_operating_system_version
  belongs_to :device_model
  has_many :logins, dependent: :destroy

  validates_presence_of :mobile_operating_system_version, :device_model, :unique_identifier
  validates_uniqueness_of :unique_identifier

end
