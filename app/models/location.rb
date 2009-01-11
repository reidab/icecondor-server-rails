class Location < ActiveRecord::Base
  WGS84_SRID = 4326

  belongs_to :user

  validates_presence_of :geom
  before_save :coordinate_times

  named_scope :recent, :limit => 25, :order => "updated_at desc"

  # Delegate to the geom object if we have one; make one if necessary
  def longitude; geom.nil? ? 0.0 : geom.x; end
  def latitude; geom.nil? ? 0.0 : geom.y; end
  def altitude; geom.nil? ? 0.0 : geom.z; end
  def longitude=(new_longitude); geom_assign(:x, new_longitude); end
  def latitude=(new_latitude); geom_assign(:y, new_latitude); end
  def altitude=(new_altitude); geom_assign(:z, new_altitude); end

  def valid_location?
    !(geom.nil? or (geom.x == "0.0" and geom.y == "0.0"))
  end

  def self.last_users_reporting(count)
    # Postgresql-specific SQL syntax
    last_users = Location.find(:all, :select => "user_id,max(created_at)", :limit => count, :order => "max desc", :group => "user_id")
    last_usernames = last_users.map{|l| l.user.id}
  end

  def self.last_updates(usernames, last_updates_per_user_count)
    usernames.map do |u| 
      Location.find(:all, :conditions => {:user_id => u}, :order => 'created_at desc', :limit => last_updates_per_user_count)
    end
  end

protected
  def validate
    self.errors.add_to_base("Fill in the lat/long fields (or click the map)") \
      unless valid_location?
  end

  def coordinate_times
    # We want an overridable as-of time, but it should be the same as
    # the updated & create times if they're saved at the same time.
    self.updated_at ||= Time.now
    self.created_at ||= self.updated_at
    self.timestamp ||= self.updated_at
  end

private
  def geom_assign(attribute, value)
    self.geom ||= Point.new(WGS84_SRID, true)
    self.geom.send("#{attribute}=".to_sym, value)
  end
end
