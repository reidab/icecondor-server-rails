class Openidentity < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :url
  validates_uniqueness_of :url
  belongs_to :user

  def self.lookup(url)
    find(:first, :conditions => {:url => cannonical(url)})
  end 

  def self.lookup_or_create(url)
    url = cannonical(url)
    lookup(url) || create_id_and_user_with_url(url)
  end

  def self.create_id_and_user_with_url(url)
      new_user = User.create!(:username => generate_username(url))
      Openidentity.create!(:user => new_user, :url => cannonical(url))
  end

  def self.cannonical(url)
    # add a trailing slash if there is no slash after the hostname
    uri = URI.parse(url)
    if uri.path.blank?
      return uri.to_s+"/"
    end
    uri.to_s
  end

  def self.generate_username(url)
    uri = URI.parse(url)
    case uri
    when URI::HTTP, URI::HTTPS
      case uri.host
      when "google.com", "www.google.com"
        profile_name_match = uri.path.match(/^\/profiles\/(.*)/)
        if profile_name_match
          username = profile_name_match[1]
        else
          username = uri.path
        end
      else
        username = uri.host + uri.path
      end
    when URI::Generic
      if uri.path.blank?
        if uri.scheme == "acct"
          username = uri.opaque.split('@').first
          else
          username = uri.opaque
        end
      else
        username = uri.path
      end
    end
    username.gsub('.', '').gsub('/','')
  end
end
