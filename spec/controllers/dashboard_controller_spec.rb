require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController do
  it "should display the front page" do
    get :index
  end
end
