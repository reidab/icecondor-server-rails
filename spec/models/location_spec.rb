require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do
  before(:each) do
    @valid_attributes = {
      :guid => "value for guid",
      :time => Time.now,
      :geom => Point.from_x_y_z(-122.5, 45.5, 10)
    }
  end

  it "should create a new instance given valid attributes" do
    Location.create!(@valid_attributes)
  end

  it "should require a valid lat/long" do
    location =  Location.create(:guid => "foo", :time => Time.now)
    location.should have(1).error_on(:geom)
  end
end
