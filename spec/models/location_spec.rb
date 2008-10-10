require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do
  before(:each) do
    @valid_attributes = {
      :guid => "value for guid",
      :time => Time.now,
      :longitude => -122.5,
      :latitude => 45.5,
      :altitude => 10.0
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
    location = Location.create!(@valid_attributes)
    location.latitude = new_latitude
    location.latitude.should == new_latitude
  end

  it "should update the longitude" do
    new_longitude = 122
    location = Location.create!(@valid_attributes)
    location.latitude = new_longitude
    location.latitude.should == new_longitude
  end

  it "should update the altitude" do
    new_altitude = 1000
    location = Location.create!(@valid_attributes)
    location.latitude = new_altitude
    location.latitude.should == new_altitude
  end
end
