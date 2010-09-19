require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Trigger do
  before(:each) do 
    @trigger = Trigger.new
    fence = mock_model(Fence)
    fence.stub!(:name).and_return("emerald city")
    user = mock_model(User)
    user.stub!(:username).and_return("bobcity")
    @trigger.fence = fence
    @trigger.user = user
  end

  it "should trigger" do
    now = Time.now
    lambda {
      @trigger.trigger!(now)
    }.should change(@trigger, :triggered_at).from(nil).to(now)
  end

  it "should know it has not been triggered" do
    @trigger.triggered?.should be_false
  end

  it "should know it has been triggered" do
    @trigger.trigger!
    @trigger.triggered?.should be_true
  end

  it "should trigger on a location inside the fence" do
    location = mock_model(Location)
    @trigger.fence.should_receive(:contains?).and_return(true)
    @trigger.check_location(location)
    @trigger.triggered?.should be_true
  end

  it "should not trigger on a location outside the fence" do
    location = mock_model(Location)
    @trigger.fence.should_receive(:contains?).and_return(false)
    @trigger.check_location(location)
    @trigger.triggered?.should be_false
  end
end
