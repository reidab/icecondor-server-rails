require File.dirname(__FILE__) + '/../spec_helper'

describe LocationsController do
  it "should process a location update" do
    identity = "http://testperson/"
    count = Location.count
    latitude = 45.5118191242218
    longitude = -122.63253271579742
    record = {"client"=>{"version"=>"20081227"}, "location"=>{"timestamp"=>"2009-01-09T18:43:56+0000", "latitude"=>latitude, "guid"=>identity, "altitude"=>"35.0", "accuracy"=>"3072.0", "longitude"=>longitude}}
    post :create, record
    Location.count.should == count+1
    location = Location.last
    location.user.openidentities.any?{|o| o.url == identity}.should be_true
    location.timestamp.should == Time.parse("2009-01-09T18:43:56+0000")
    location.geom.y.should == latitude
    location.geom.x.should == longitude
  end

  it "should display a user's location summary" do
    get :index, {:id => 'bob'}
  end
end
