require File.dirname(__FILE__) + '/../spec_helper'

describe SessionController do
  it "should attempt to authenticate an openid url" do
    openid = "http://provider/username"
    provider_url = "http://provider"
    obrain = mock("openid controller")
    obrain.should_receive(:send_redirect?).and_return(true)
    obrain.should_receive(:redirect_url).and_return(provider_url)
    consumer = mock("openid consumer")
    consumer.should_receive(:begin).with(openid).and_return(obrain)
    controller.should_receive(:consumer).and_return(consumer)

    post :login, {:openid_identifier => openid }
    response.should redirect_to(provider_url)
  end

  it "should complete the authentication of an openid url" do
    openid = "http://phoneyid"
    openid_response = mock("openid response")
    openid_response.should_receive(:status).and_return(OpenID::Consumer::SUCCESS)
    openid_response.stub!(:display_identifier).and_return(openid)
    consumer = mock("openid consumer")
    consumer.should_receive(:complete).and_return(openid_response)
    controller.should_receive(:consumer).and_return(consumer)

    post :complete
    controller.current_user.should == openid
  end
end
