require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Openidentity do
  it "should create a username from a URL" do
    url="http://name.openidprovider.com"
    Openidentity.generate_username(url).should == "nameopenidprovidercom"
    url="donpG1"
    Openidentity.generate_username(url).should == url
    url="urn:uuid:c7b082ce-d75a-424d-afd7-6da2dc81dbdc"
    Openidentity.generate_username(url).should == "uuid:c7b082ce-d75a-424d-afd7-6da2dc81dbdc"
  end

end
