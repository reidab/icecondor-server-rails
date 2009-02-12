require File.dirname(__FILE__) + '/../spec_helper'

describe LocationsController do
  fixtures :users, :openidentities
  include SessionSpecHelper

  it "should process a 2008-style location update" do
    identity = "http://testperson/"
    latitude = 45.5118191242218
    longitude = -122.63253271579742
    record = {"client"=>{"version"=>"20081227"}, "location"=>{"timestamp"=>"2009-01-09T18:43:56+0000", "latitude"=>latitude, "guid"=>identity, "altitude"=>"35.0", "accuracy"=>"3072.0", "longitude"=>longitude}}
    user = mock_model(User)
    openid = mock_model(Openidentity)
    openid.should_receive(:user).and_return(user)
    Openidentity.should_receive(:lookup_or_create).with(identity).and_return(openid)

    lambda do
      post :create, record
    end.should change(Location, :count).by(1)
    location = Location.last
    location.timestamp.should == Time.parse("2009-01-09T18:43:56+0000")
    location.geom.y.should == latitude
    location.geom.x.should == longitude
  end

  it "should process an OAUTH authenticated location update" do
    latitude = 45.5118191242218
    longitude = -122.63253271579742
    token_string = "bogus"
    record = {"client"=>{"version"=>"20081227"}, "location"=>{"timestamp"=>"2009-01-09T18:43:56+0000", "latitude"=>latitude, "altitude"=>"35.0", "accuracy"=>"3072.0", "longitude"=>longitude}}
    record.merge!({"oauth_token"=>token_string}) # make it an OAUTH request
    record.merge!({"format"=>"json"}) # the client requests json
    controller.should_receive(:oauthenticate).and_return(true)
    token = mock("token")
    user = mock_model(User)
    token.should_receive(:user).and_return(user)
    OauthToken.should_receive(:find_by_token).with(token_string).and_return(token)

    lambda do
      post :create, record
    end.should change(Location, :count).by(1)
    response.should be_success
    response.body.should match(/id/)
  end

  it "should display a public user's location summary" do
    get :index, {:id => 'http://first.cc/'}
    response.should be_success
  end

  it "should redirect to login when an unlogged-in session asks for a protected user's location" do
    get :index, {:id => 'http://sallysecret/'}
    response.should redirect_to("http://test.host/session/login_screen") #why
  end

  it "should display a protected user's own location" do
    login users(:sally)
    get :index, {:id => 'http://sallysecret/'}
    response.should be_success
  end

  it "should redirect to the home page when the id is unknown" do
    get :index, {:id => 'http://bogusoid'}
    response.should redirect_to('http://test.host/')
  end

  it "should display a public user's location summary as an RSS feed" do
    get :index, {:id => 'http://first.cc/'}, {}, {:format => :rss}
    response.should be_success
  end
end
