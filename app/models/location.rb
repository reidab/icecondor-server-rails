class Location < ActiveRecord::Base
  named_scope :recent, :limit => 25, :order => "updated_at desc"

protected
  def validate
    if geom.nil? or geom.x == 0.0 or geom.y == 0.0
      errors.add(:geom, "Location must be valid")
    end
  end
end
