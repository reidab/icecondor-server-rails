require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  fixtures :users, :openidentities

  it "should find a user by openid" do
    url = openidentities(:quentin).url
    User.find_by_openid(url).should == users(:quentin)
  end

end
