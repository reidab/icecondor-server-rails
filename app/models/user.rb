class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :openidentities
  has_many :client_applications
  has_many :tokens, :class_name=>"OauthToken",:order=>"authorized_at desc",:include=>[:client_application]
  has_many :locations
  has_many :fences
  has_many :triggers

  before_create :set_defaults

  def self.find_by_openid(url)
    openid = Openidentity.find_by_url(url)
    return openid.user if openid
  end

  def set_defaults
    self.access_status ||= "private"
  end

  def oauth_access_for?(service)
    true if oauth_token(service)
  end

  def oauth_token(service)
    client = ClientApplication.find_by_name(service)
    if client
      tokens.find_by_client_application_id(client.id)
    end
  end

  def foursquare
    cred = SETTINGS["foursquare"]["oauth"]
    oauth = Foursquare::OAuth.new(cred["key"], cred["secret"])
    access_token = oauth_token("foursquare")
    oauth.authorize_from_access(access_token.token, access_token.secret)
    Foursquare::Base.new(oauth)
  end

  def inside_fences
    fences.select{|fence| fence.contains?(locations.last)}
  end

  def blur?
    inside_fences.any?{|fence| fence.triggers.any?{|trigger| trigger.action == "blur"}} 
  end
end
