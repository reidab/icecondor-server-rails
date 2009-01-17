require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do
  fixtures :locations, :users

  before(:each) do
    @valid_attributes = {
      :user_id => users(:u1).id,
      :timestamp => Time.now,
      :longitude => -122.5,
      :latitude => 45.5,
      :altitude => 10.0,
      :created_at => '2008-10-11T04:05:06'
    }
  end

  it "should create a new instance given valid attributes" do
    location = Location.create!(@valid_attributes)
  end

  it "should require a valid lat/long" do
    location =  Location.create(:user => users(:u1), :timestamp => Time.now)
    location.should have(1).error_on(:geom)
  end

  it "should update the time" do
    new_time = Time.parse('2008-10-12T05:15:00')
    location = locations(:fu0)
    location.timestamp = new_time
    location.timestamp.should == new_time
  end

  it "should count the location records for a given user" do
    Location.count_for_user(users(:quentin)).should == 1
  end
end
