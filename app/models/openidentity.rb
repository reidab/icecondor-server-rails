class Openidentity < ActiveRecord::Base
  belongs_to :user

  def self.lookup(url)
    find(:first, :conditions => {:url => cannonical(url)})
  end 

  def self.lookup_or_create(url)
    lookup(url) || create_id_and_user_with_url(url)
  end

  def self.create_id_and_user_with_url(url)
      new_user = User.create!
      Openidentity.create!(:user => new_user, :url => url)
  end

  def self.cannonical(url)
    # add a trailing slash if there is no slash after the hostname
    uri = URI.parse(url)
    if uri.path.blank?
      return uri.to_s+"/"
    end
    uri.to_s
  end
end
