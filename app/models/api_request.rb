class ApiRequest < ActiveRecord::Base

  include HasNetworkType

  belongs_to :user
  belongs_to :login

  validates_presence_of :ip, :path, :params

end
