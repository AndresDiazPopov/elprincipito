class Identity < ActiveRecord::Base

  has_paper_trail

  scope :facebook, -> {where(:provider => :facebook)}
  scope :twitter, -> {where(:provider => :twitter)}
  scope :google, -> {where(:provider => :google_oauth2)}
  
  belongs_to :user
  validates_presence_of :user, :provider, :uid, :token
  validates_uniqueness_of :uid, :scope => :provider
  validates_uniqueness_of :provider, :scope => :user
  validates_inclusion_of :provider, :in => %w( twitter facebook google_oauth2 )

  validate do
    errors.add :base, "Twitter provider must have token secret" unless (provider != "twitter" or !token_secret.nil?)
  end

  def self.find_for_oauth(auth)
    identity = find_or_create_by(uid: auth.uid, provider: auth.provider)
    identity.update_attributes(:token => auth.credentials.token, :token_secret => auth.credentials.secret)
    identity
  end
end