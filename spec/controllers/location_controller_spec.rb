require File.dirname(__FILE__) + '/../spec_helper'

describe LocationsController do
  it "should process a 2008-style location update" do
    identity = "http://testperson/"
    count = Location.count
    latitude = 45.5118191242218
    longitude = -122.63253271579742
    record = {"client"=>{"version"=>"20081227"}, "location"=>{"timestamp"=>"2009-01-09T18:43:56+0000", "latitude"=>latitude, "guid"=>identity, "altitude"=>"35.0", "accuracy"=>"3072.0", "longitude"=>longitude}}
    user = mock_model(User)
    openid = mock_model(Openidentity)
    openid.should_receive(:user).and_return(user)
    Openidentity.should_receive(:lookup_or_create).with(identity).and_return(openid)

    post :create, record
    Location.count.should == count+1
    location = Location.last
    location.timestamp.should == Time.parse("2009-01-09T18:43:56+0000")
    location.geom.y.should == latitude
    location.geom.x.should == longitude
  end

  it "should process an OAUTH authenticated location update" do
    latitude = 45.5118191242218
    longitude = -122.63253271579742
    token_string = "bogus"
    record = {"client"=>{"version"=>"20081227"}, "location"=>{"timestamp"=>"2009-01-09T18:43:56+0000", "latitude"=>latitude, "altitude"=>"35.0", "accuracy"=>"3072.0", "longitude"=>longitude}, "oauth_token"=>token_string}
    controller.should_receive(:oauthenticate).and_return(true)
    token = mock("token")
    user = mock_model(User)
    token.should_receive(:user).and_return(user)
    OauthToken.should_receive(:find_by_token).with(token_string).and_return(token)

    post :create, record
  end

  it "should display a user's location summary" do
    get :index, {:id => 'bob'}
  end
end
