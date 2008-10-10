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
    new_latitude = 80
    location = Location.create!(@valid_attributes)
    location.latitude = new_latitude
    location.latitude.should == new_latitude
  end
end
