require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do
  fixtures :locations

  before(:each) do
    @valid_attributes = {
      :guid => "value for guid",
      :time => Time.now,
      :longitude => -122.5,
      :latitude => 45.5,
      :altitude => 10.0,
      :timestamp => '2008-10-11T04:05:06'
    }
  end

  it "should create a new instance given valid attributes" do
    location = Location.create!(@valid_attributes)
  end

  it "should require a valid lat/long" do
    location =  Location.create(:guid => "foo", :time => Time.now)
    location.should have(1).error_on(:geom)
  end

  it "should update the latitude" do
    new_latitude = 45 
    location = locations(:one)
    location.latitude = new_latitude
    location.latitude.should == new_latitude
  end

  it "should update the longitude" do
    new_longitude = 122
    location = locations(:one)
    location.latitude = new_longitude
    location.latitude.should == new_longitude
  end

  it "should update the altitude" do
    new_altitude = 1000
    location = locations(:one)
    location.altitude = new_altitude
    location.altitude.should == new_altitude
  end

  it "should update the time" do
    new_time = '2008-10-12T05:15:00'
    location = locations(:one)
    location.timestamp = new_timestamp
    location.timestamp.should == new_timestamp
  end
end
