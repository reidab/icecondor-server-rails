require File.dirname(__FILE__) + '/../../spec_helper'

describe "/dashboard/map" do
  it "should render valid XHTML" do
    assigns[:locations] = []
    template.should_receive(:google_map)
    render "/dashboard/map"
    response.should have_tag('div.heading')
  end
end
