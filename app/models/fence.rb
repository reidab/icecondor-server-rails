class Fence < ActiveRecord::Base
  belongs_to :user

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
end
