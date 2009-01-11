require File.dirname(__FILE__) + '/../spec_helper'

describe LocationsController do
  it "should process a location update" do
    record = {"client"=>{"version"=>"20081227"}, "location"=>{"timestamp"=>"2009-01-09T18:43:56+0000", "latitude"=>"45.5118191242218", "guid"=>"donpG1", "altitude"=>"35.0", "accuracy"=>"3072.0", "longitude"=>"-122.63253271579742"}}
    post :create, record
  end

  it "should display a user's location summary" do
    get :index, {:id => 'bob'}
  end
end
