require File.dirname(__FILE__) + '/../spec_helper'

describe TriggersController do
  it "should display the front page" do
    get :index
    response.should be_success
  end
end

