class Location < ActiveRecord::Base
  named_scope :recent, :limit => 25, :order => "updated_at desc"
end
