require File.dirname(__FILE__) + '/../spec_helper'

describe LocationsController do
  fixtures :users, :openidentities
  include SessionSpecHelper

  it "should process an OAUTH authenticated location update" do
    latitude = 45.5118191242218
    longitude = -122.63253271579742
    token_string = "bogus"
    record = {"client"=>{"version"=>"20081227"}, "location"=>{"timestamp"=>"2009-01-09T18:43:56+0000", "latitude"=>latitude, "altitude"=>"35.0", "accuracy"=>"3072.0", "longitude"=>longitude}}
    record.merge!({"oauth_token"=>token_string}) # make it an OAUTH request
    record.merge!({"format"=>"json"}) # the client requests json
    controller.should_receive(:oauth_required).and_return(true)
    token = mock("token")
    user = mock_model(User)
    locations = mock("locations")
    location = mock_model(Location)
    user.should_receive(:username).and_return("bob")
    user.should_receive(:triggers).and_return([])
    user.should_receive(:locations).and_return(locations)
    token.should_receive(:user).and_return(user)
    token.should_receive(:token).and_return(token_string)
    locations.should_receive(:last).and_return(location)
    controller.should_receive(:current_token).twice.and_return(token)
    Location.should_receive(:build).with(record["location"].merge!({"user"=>user})).and_return(location)
    location.should_receive(:save).and_return(true)
    location.should_receive(:user).and_return(user)

    post :create, record
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
