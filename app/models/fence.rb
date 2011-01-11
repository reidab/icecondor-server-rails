class Fence < ActiveRecord::Base
  belongs_to :user
  has_many :triggers, :dependent => :destroy
  validates_presence_of :name

  def area_in_sq_ft
    area = ActiveRecord::Base.connection.execute("select ST_Area(geom) from fences where id=#{id}")
    #staging server needs reprojecting built into postgis
    #area = ActiveRecord::Base.connection.execute("select ST_Area(ST_Transform(geom,2249)) from fences where id=#{id}")
    area[0]["st_area"].to_f
  end

  def count_points
    area = ActiveRecord::Base.connection.execute("select ST_NPoints(geom) from fences where id=#{id}")
    area[0]["st_npoints"].to_i
  end

  def contains?(location)
    area = ActiveRecord::Base.connection.execute("select ST_Intersects(ST_GeomFromEWKT('#{location.geom.as_ewkt}'),geom) from fences where id=#{id}")
    area[0]["st_intersects"]=='t'
  end

  def as_locationcommonsjson
    {"name" => name, "geometry" => {"type" => "polygon", "coordinates" => [ geom.first.points.map{|p| [p.y,p.x]} ]}}.to_json
  end

  def centerpoint
    area = ActiveRecord::Base.connection.execute("select ST_AsEWKT(ST_Centroid(geom)) from fences where id=#{id}")[0]
    # hack!
    srid = area["st_asewkt"].match(/SRID=(\d*)/)[1]
    latlng = area["st_asewkt"].match(/POINT\((.*)\)/)[1].split
    {:srid => srid, :latitude => latlng[1], :longitude => latlng[0]}
  end
end

class GeoRuby::SimpleFeatures::Polygon
  def to_geojson
    {"type"=>"Polygon",
     "coordinates"=> rings.map{|r| r.points[0..-2].map{|p| [p.y,p.x]}}
    }.to_json
  end
end
