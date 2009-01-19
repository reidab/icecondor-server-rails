require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Openidentity do
  it "should create a username from a URL" do
    url="http://name.openidprovider.com"
    Openidentity.generate_username(url).should == "nameopenidprovidercom"
  end

end
