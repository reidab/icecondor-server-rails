class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :openidentities, :dependent => :destroy
  has_many :client_applications, :dependent => :destroy
  has_many :tokens, :class_name=>"OauthToken",
                    :order=>"authorized_at desc",
                    :include=>[:client_application],
                    :dependent => :destroy
  has_many :locations, :dependent => :destroy
  has_many :fences, :dependent => :destroy
  has_many :triggers, :dependent => :destroy
  has_many :scripts, :dependent => :destroy
  has_many :friends, :through => :friendships
  has_many :friendships

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

  def webfinger_local_address
  end
end
