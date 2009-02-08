require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController do
  it "should display the front page" do
    get :index
    respose.should be_success
  end
end
