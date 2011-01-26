class GeoService < ActiveRecord::Base
  has_one :hook, :as => :target
end
