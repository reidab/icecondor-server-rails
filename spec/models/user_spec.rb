require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users, :openidentities

  it "should find a user by openid" do
    url = openidentities(:quentin).url
    User.find_by_openid(url).should == users(:quentin)
  end

  it "should create a user with default settings" do
    user = User.create!(:username => "testing")
    user.access_status.should == "private"
  end
end
