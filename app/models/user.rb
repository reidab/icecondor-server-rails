class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :openidentities
  has_many :client_applications
  has_many :tokens, :class_name=>"OauthToken",:order=>"authorized_at desc",:include=>[:client_application]
  has_many :locations

  def self.find_by_openid(url)
    openid = Openidentity.find_by_url(url)
    return openid.user if openid
  end
end
