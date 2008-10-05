class Location < ActiveRecord::Base
  WGS84_SRID = 4326

  named_scope :recent, :limit => 25, :order => "updated_at desc"

  def longitude
    geom or geom.x
  end
  def latitude
    geom or geom.y
  end
  def altitude
    geom or geom.z
  end
  def longitude=(new_longitude)
    geom_assign(:x=, new_longitude)
  end
  def latitude=(new_latitude)
    geom_assign(:y=, new_latitude)
  end
  def altitude=(new_altitude)
    geom_assign(:z=, new_altitude)
  end

protected
  def validate
    if geom.nil? or geom.x == 0.0 or geom.y == 0.0
      errors.add(:geom, "Latitude/longitude must be valid")
    end
  end

  def geom_assign(setter, value)
    self.geom ||= Point.new(WGS84_SRID)
    self.geom.send(setter, value)
  end
end
